import 'dart:io';
import 'package:Digibells/constants/app_constants.dart';
import 'package:Digibells/main.dart';
import 'package:Digibells/screens/ViewQRCode/order_sticker/bloc/order_sticker_event.dart';
import 'package:Digibells/screens/payment/bloc/payment_event.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../Address/get_address/bloc/get_address_bloc.dart';
import '../payment/bloc/payment_bloc.dart';
import '../payment/bloc/payment_state.dart';
import 'order_sticker/bloc/order_sticker_bloc.dart';
import 'order_sticker/bloc/order_sticker_state.dart';

class ViewQRCodeScreen extends StatefulWidget {
  final String qrCode;
  final String id;

  ViewQRCodeScreen({super.key, required this.qrCode, required this.id});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderStickerBloc>(create: (_) => OrderStickerBloc()),
        BlocProvider<GetAddressScreenBloc>(create: (_) => GetAddressScreenBloc()),
        BlocProvider<PaymentBloc>(create: (_) => PaymentBloc()),
      ],
      child: ViewQRCodeScreen(
        qrCode: '',
        id: '',
      ),
    );
  }

  @override
  State<ViewQRCodeScreen> createState() => _ViewQRCodeScreenState();
}

class _ViewQRCodeScreenState extends State<ViewQRCodeScreen> {
  String qrText = "Scan QR code to call Owner";
  String address = "";
  bool addressEmpty = true;

  /// RazorPay
  Razorpay? razorpay;

  @override
  void initState() {
    BlocProvider.of<GetAddressScreenBloc>(context).add(
      PerformGetAddressScreenEvent(),
    );

    /// RazorPay
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    super.initState();
  }

  /// Razor Pay
  Future<void> openCheckout(int amount) async {
    var options = {
      "key": APIConstants.razorPay_ID /*?? key*/,
      "amount": amount * 100,
      // Convert Paisa to Rupees
      'name': prefs?.getString(AppConstants.userName) ?? '',

      // 'retry': {'enabled': true, 'max_count': 3},
      'send_sms_hash': true,
      "currency": "INR",
      'timeout': 360,
      // in seconds
      'prefill': {'contact': prefs?.getString(AppConstants.userContact) ?? '', 'email': prefs?.getString(AppConstants.userEmail) ?? ''},
      'theme': {
        'color': '#408279',
      }
    };
    razorpay!.open(options);
  }

  /// Razor Pay
  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    AlertUtils.showToast("Payment Successful - ${response.paymentId!}");
    payment(response.paymentId ?? '');
  }

  /// Razor Pay
  void handlerErrorFailure(PaymentFailureResponse response) {
    AlertUtils.showToast("Payment Failed - ${response.message!}");
    logger.e('FAILED DATA ${response.toString()}');
  }

  /// Razor Pay
  void handlerExternalWallet(ExternalWalletResponse response) {
    AlertUtils.showToast("EXTERNAL_WALLET: ${response.walletName!}");
  }

  _showEmptyAddressDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Address Empty!',
            style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Please add delivery address for order QR code.',
            style: AppStyles.black_17_w600.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppScreens.savedAddress, arguments: {'fromShopping': false, 'fromDrawer': false});
              },
              child: Text(
                'Add',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  _showConfirmationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Buy at only Rs 100/-',
            style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Are you sure to order QR sticker?',
            style: AppStyles.black_17_w600.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                if (addressEmpty == true) {
                  Navigator.of(context).pop();
                  _showEmptyAddressDialog();
                } else {
                  Navigator.of(context).pop();
                  openCheckout(100);
                }
              },
              child: Text(
                'Yes',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      appBar: AppBar(
        backgroundColor: AppStyles.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppStyles.black,
          ),
        ),
        title: Text(
          "Your QR code",
          style: AppStyles.black_24_w300,
        ),
      ),
      body: BlocConsumer<OrderStickerBloc, OrderStickerState>(
        listener: (context, orderState) {
          if (orderState.isCompleted) {
            AlertUtils.showToast("QR sticker ordered successfully.");
            Navigator.pushNamed(context, AppScreens.stickerOrderHistoryScreen);
          }
        },
        builder: (context, orderState) {
          return BlocConsumer<GetAddressScreenBloc, GetAddressScreenState>(
            listener: (context, state) {
              if (state.isCompleted) {
                addressEmpty = state.getAllAddressModel?.data?.where((items) => items.isDefaultAddress == true).length == 0 ? true : false;
                if (addressEmpty == false)
                  address =
                      "${state.getAllAddressModel?.data?.where((items) => items.isDefaultAddress == true).first.house}, ${state.getAllAddressModel?.data?.where((items) => items.isDefaultAddress == true).first.landmark}, ${state.getAllAddressModel?.data?.where((items) => items.isDefaultAddress == true).first.area}, ${state.getAllAddressModel?.data?.where((items) => items.isDefaultAddress == true).first.city}, ${state.getAllAddressModel?.data?.where((items) => items.isDefaultAddress == true).first.pinCode}";
              }
            },
            builder: (context, state) {
              return BlocConsumer<PaymentBloc, PaymentState>(
                listener: (context, paymentState) {
                  if (paymentState.isCompleted) {
                    buySticker(paymentState.paymentModel?.data?.sId ?? '', paymentState.paymentModel?.data?.transectionId ?? '');
                  }
                },
                builder: (context, paymentState) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 30.h, bottom: 10.h),
                          child: Column(
                            children: [
                              Container(
                                height: 410.h,
                                width: 400.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 3.w, color: AppStyles.switchColor),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Column(
                                    children: [
                                      widget.qrCode != ""
                                          ? CachedNetworkImage(
                                              height: MediaQuery.of(context).size.height / 2.95,
                                              imageUrl: "${APIConstants.imageUrl}${widget.qrCode}",
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              progressIndicatorBuilder: (context, url, progress) => Center(
                                                child: CircularProgressIndicator(
                                                  value: progress.progress,
                                                  color: AppStyles.primary,
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              "",
                                              height: 270.h,
                                            ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      SizedBox(
                                        width: 230.w,
                                        child: Text(
                                          qrText,
                                          textAlign: TextAlign.center,
                                          style: AppStyles.black_24_w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 70.h,
                              ),
                              Center(
                                child: SizedBox(
                                    width: 300.w,
                                    height: 50.h,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await _downloadImage(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: AppStyles.white,
                                        padding: EdgeInsets.symmetric(vertical: 11.h),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: AppStyles.primary),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        'Download',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.primary,
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Center(
                                child: SizedBox(
                                  width: 300.w,
                                  height: 55.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showConfirmationDialog();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppStyles.primary,
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      'Buy QR Code Sticker At Rs 100',
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        child: LoaderWidget(),
                        visible: state.isLoading || paymentState.isLoading || orderState.isLoading,
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    String imgUrl = "${APIConstants.imageUrl}${widget.qrCode}";

    try {
      // Request storage permission (for Android versions <10)
      var status = await Permission.storage.request();
      if (status.isGranted) {
        // Use path_provider to get an app-specific directory
        Directory? appDir;
        if (Platform.isAndroid) {
          // On Android, use external storage directories for app-specific files
          appDir = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          // On iOS, use the application documents directory
          appDir = await getApplicationDocumentsDirectory();
        }

        if (appDir == null) {
          throw Exception("Unable to access directory");
        }

        // Ensure the directory exists
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }

        // Construct file path and download the image
        Dio dio = Dio();
        String fileName = imgUrl.split('/').last;
        String filePath = '${appDir.path}/$fileName';

        Response response = await dio.download(imgUrl, filePath);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved to $filePath')),
          );
        } else {
          throw Exception('Failed to download image. Status code: ${response.statusCode}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission denied')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image: ${e.toString()}')),
      );
    }
  }

  Future<void> payment(String paymentId) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {"razorpay_payment_id": paymentId, "paymentStatus": true};

      BlocProvider.of<PaymentBloc>(context).add(
        PerformPaymentEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> buySticker(String paymentId, String transactionalId) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "deliveryAddress": address,
        "qrId": widget.id,
        "totalPrice": 100,
        "totalQuantity": 1,
        'paymentId': paymentId,
        'transectionId': transactionalId
      };

      BlocProvider.of<OrderStickerBloc>(context).add(
        PerformOrderStickerEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
