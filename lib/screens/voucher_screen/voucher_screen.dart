import 'package:Digibells/screens/shopping_cart/get_vouchers/bloc/get_vouchers_bloc.dart';
import 'package:Digibells/screens/shopping_cart/get_vouchers/bloc/get_vouchers_event.dart';
import 'package:Digibells/utils/app_styles.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../app_screens/app_screens.dart';
import '../shopping_cart/get_vouchers/bloc/get_vouchers_state.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetVouchersBloc>(create: (_) => GetVouchersBloc()),
      ],
      child: VoucherScreen(),
    );
  }

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  void initState() {
    BlocProvider.of<GetVouchersBloc>(context).add(
      PerformGetVouchersEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      appBar: AppBar(
        backgroundColor: AppStyles.white,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        // toolbarHeight: 90.h,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppStyles.black,
          ),
        ),
        title: Text(
          "Vouchers",
          style: AppStyles.black_24_w300,
        ),
      ),
      body: BlocConsumer<GetVouchersBloc, GetVouchersState>(
        listener: (context, state) {
          if (state.isCompleted) {}
        },
        builder: (context, state) {
          return Stack(
            children: [
              state.getVouchersModel?.data?.length == 0
                  ? Center(
                      child: Text(
                        "No vouchers available.",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 25.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(context, AppScreens.shoppingCartScreen, arguments: {
                                          'voucherCode': state.getVouchersModel?.data?[index].voucherCode,
                                          'discount': state.getVouchersModel?.data?[index].discount
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: Offset(0, 1),
                                              blurRadius: 8.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        height: 122.h,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.getVouchersModel?.data?[index].voucherCode ?? '',
                                                style: TextStyle(color: Colors.black, fontSize: 19.w, fontWeight: FontWeight.w600),
                                              ),
                                              // Container(
                                              //   decoration:
                                              //       BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey)),
                                              //   child: Padding(
                                              //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                              //     child: Text('Apply'),
                                              //   ),
                                              // ),
                                              Text(
                                                '${state.getVouchersModel?.data?[index].discount.toString() ?? ''}% OFF',
                                                style: TextStyle(color: Colors.black54, fontSize: 17.w, fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Divider(),
                                              Center(
                                                child: Text(
                                                  "*Terms and Conditions Apply",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15.w,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.getVouchersModel?.data?.length ?? 0)
                          ],
                        ),
                      ),
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
}
