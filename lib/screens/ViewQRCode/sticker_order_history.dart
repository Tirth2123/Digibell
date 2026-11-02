import 'package:Digibells/screens/ViewQRCode/get_my_order_details/bloc/get_my_order_details_bloc.dart';
import 'package:Digibells/screens/ViewQRCode/get_my_order_details/bloc/get_my_order_details_event.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/asset_path.dart';
import '../../utils/app_styles.dart';
import 'get_my_order_details/bloc/get_my_order_details_state.dart';

class StickerOrderHistoryScreen extends StatefulWidget {
  const StickerOrderHistoryScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetMyOrderBloc>(create: (_) => GetMyOrderBloc()),
      ],
      child: const StickerOrderHistoryScreen(),
    );
  }

  @override
  State<StickerOrderHistoryScreen> createState() => _StickerOrderHistoryScreenState();
}

class _StickerOrderHistoryScreenState extends State<StickerOrderHistoryScreen> {
  void initState() {
    BlocProvider.of<GetMyOrderBloc>(context).add(
      PerformGetMyOrderEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppStyles.white,
        elevation: 0.0,
        // toolbarHeight: 90.h,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              AppScreens.firstTimeHomeScreen,
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppStyles.black,
          ),
        ),
        title: Text(
          "Sticker Order History",
          style: AppStyles.black_24_w300,
        ),
      ),
      body: BlocConsumer<GetMyOrderBloc, GetMyOrderState>(
        listener: (context, state) async {
          if (state.isCompleted) {}
        },
        builder: (context, state) {
          if (state.isLoading) {
            return LoaderWidget();
          }
          if (state.isCompleted && state.getMyOrderModel?.data?.isEmpty == true) {
            return Center(child: Text('No orders found.'));
          }

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 30.h, bottom: 20.h),
                child: state.getMyOrderModel?.data?.where((item) => item.qrDetails?.isNotEmpty ?? false).length == 0
                    ? Center(
                        child: Text("Sticker order history empty."),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.getMyOrderModel?.data?.where((item) => item.qrDetails?.isNotEmpty ?? false).length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final filteredOrders = state.getMyOrderModel?.data?.where((item) => item.qrDetails?.isNotEmpty ?? false).toList();

                                  final qrDetails = filteredOrders?[index].qrDetails?.first;
                                  final orderDetails = filteredOrders?[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 35.h),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: AppStyles.white,
                                        boxShadow: [BoxShadow(color: AppStyles.bordercolor, blurRadius: 10.0)],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h, bottom: 20.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Order Id:", style: AppStyles.hintText_15_w400.copyWith(fontSize: 14.sp)),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Text(qrDetails?.sId ?? "",

                                                          // "ABC-1234567",
                                                          style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(orderDetails?.deliveryDate == null ? "Expected Date" : "Delivered On",
                                                        style: AppStyles.hintText_15_w400.copyWith(fontSize: 14.sp)),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                        orderDetails?.deliveryDate == null
                                                            ? orderDetails?.expectedDeliveryDate ?? ''
                                                            : orderDetails?.deliveryDate ?? "",
                                                        // "29/05/24",
                                                        style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 80.h,
                                                  width: 80.h,
                                                  child: qrDetails?.qrImage != null
                                                      ? Image.network(
                                                          "${APIConstants.imageUrl}${qrDetails?.qrImage ?? ""}",
                                                          fit: BoxFit.cover,
                                                          height: 80.h,
                                                          width: 80.h,
                                                        )
                                                      : Image.asset(
                                                          ImageAssetPath.qrCode,
                                                          fit: BoxFit.cover,
                                                          height: 80.h,
                                                          width: 80.h,
                                                        ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Order status : ",
                                                            style: AppStyles.hintText_15_w400.copyWith(fontWeight: FontWeight.w500)),
                                                        Text(
                                                          "${orderDetails?.deliveryStatus}",
                                                          style: AppStyles.black_17_w600.copyWith(
                                                            fontSize: 15.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Total Price :    ",
                                                            style: AppStyles.hintText_15_w400.copyWith(fontWeight: FontWeight.w500)),
                                                        SizedBox(
                                                          width: 3.w,
                                                        ),
                                                        Text(
                                                          "${orderDetails?.totalPrice ?? 0}/-",
                                                          // "500/-",
                                                          style: AppStyles.black_17_w600.copyWith(
                                                            fontSize: 15.sp,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
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
