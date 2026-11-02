
import 'package:Digibells/screens/ActivateQrCode/activate_qr_code/bloc/activate_qr_code_bloc.dart';
import 'package:Digibells/screens/ActivateQrCode/activate_qr_code/bloc/activate_qr_code_event.dart';
import 'package:Digibells/utils/alert_utils.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

import '../../app_screens/app_screens.dart';
import '../../utils/app_utils.dart';
import '../../utils/stream_builder.dart';
import 'activate_qr_code/bloc/activate_qr_code_state.dart';

class QRScanScreen extends StatefulWidget {
  dynamic id;
  QRScanScreen({super.key, required this.id});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ActivateQRCodeBloc>(create: (_) => ActivateQRCodeBloc()),
      ],
      child: QRScanScreen(
        id: "",
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ActivateQRCodeBloc, ActivateQRCodeState>(
        listener: (context, state) {
          if (state.isCompleted) {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
            StreamUtil.bottomNavigationIndex.add(0);
            AlertUtils.showToast("QR activated successfully.");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        QRView(
                          overlay: QrScannerOverlayShape(
                            borderColor: Colors.white,
                            cutOutHeight: 370.h,
                            cutOutWidth: 300.w,
                          ),
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        ),
                        Positioned(
                            top: 50.h,
                            left: 10.w,
                            child: IconButton(
                              color: Colors.white,
                              iconSize: 28.w,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ],
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: Center(
                  //       child: Container(
                  //     height: 55.h,
                  //     width: 55.w,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.zero,
                  //         border: Border.all(
                  //           width: 2,
                  //           color: Colors.white,
                  //         )),
                  //   )),
                  // )
                ],
              ),
              Visibility(
                child: LoaderWidget(),
                visible: state.isLoading,
              )
            ],
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedUrl = scanData.code; // Scanned QR code result
        if (scannedUrl != null) {
          activateQR(scannedUrl);
        }
        logger.wtf("YOUR SCANNED URL ==> $scannedUrl");
        // _registerQR(scannedUrl!); // Call your registration method
      });
    });
  }

  Future<void> activateQR(
    dynamic url,
  ) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "url": url,
        "qrId": widget.id,
      };
      BlocProvider.of<ActivateQRCodeBloc>(context).add(
        PerformActivateQRCodeEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
