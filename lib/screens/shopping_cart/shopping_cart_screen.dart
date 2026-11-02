import 'package:Digibells/constants/asset_path.dart';
import 'package:Digibells/screens/Address/get_address/bloc/get_address_bloc.dart';
import 'package:Digibells/screens/shopping_cart/get_cart_items/bloc/get_cart_items_bloc.dart';
import 'package:Digibells/screens/shopping_cart/get_cart_items/bloc/get_cart_items_event.dart';
import 'package:Digibells/screens/shopping_cart/remove_cart_item/bloc/remove_cart_item_bloc.dart';
import 'package:Digibells/screens/shopping_cart/remove_cart_item/bloc/remove_cart_item_event.dart';
import 'package:Digibells/screens/shopping_cart/remove_cart_item/bloc/remove_cart_item_state.dart';
import 'package:Digibells/screens/shopping_cart/update_cart_quantity/bloc/update_cart_quantity_bloc.dart';
import 'package:Digibells/screens/shopping_cart/update_cart_quantity/bloc/update_cart_quantity_event.dart';
import 'package:Digibells/screens/shopping_cart/update_cart_quantity/bloc/update_cart_quantity_state.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../main.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../ViewQRCode/order_sticker/bloc/order_sticker_bloc.dart';
import '../ViewQRCode/order_sticker/bloc/order_sticker_event.dart';
import '../ViewQRCode/order_sticker/bloc/order_sticker_state.dart';
import '../payment/bloc/payment_bloc.dart';
import '../payment/bloc/payment_event.dart';
import '../payment/bloc/payment_state.dart';
import 'get_cart_items/bloc/get_cart_items_state.dart';
import 'get_cart_items/model/get_cart_items_model.dart';

class ShoppingCartScreen extends StatefulWidget {
  String voucherCode;
  int discount;
  ShoppingCartScreen({super.key, required this.voucherCode, required this.discount});

  static Widget create(int discount, String voucherCode) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetCartItemsBloc>(create: (_) => GetCartItemsBloc()),
        BlocProvider<GetAddressScreenBloc>(create: (_) => GetAddressScreenBloc()),
        BlocProvider<RemoveCartItemBloc>(create: (_) => RemoveCartItemBloc()),
        BlocProvider<OrderStickerBloc>(create: (_) => OrderStickerBloc()),
        BlocProvider<UpdateCartQuantityBloc>(create: (_) => UpdateCartQuantityBloc()),
        BlocProvider<PaymentBloc>(create: (_) => PaymentBloc()),
      ],
      child: ShoppingCartScreen(
        discount: discount,
        voucherCode: voucherCode,
      ),
    );
  }

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  Map<int, int> productCounts = {};
  int subtotal = 0;
  int total = 0;
  String address = '';
  String houseNo = '';
  double discountAmount = 0.0;

  /// RazorPay
  Razorpay? razorpay;

  void initState() {
    BlocProvider.of<GetAddressScreenBloc>(context).add(
      PerformGetAddressScreenEvent(),
    );
    BlocProvider.of<GetCartItemsBloc>(context).add(
      PerformGetCartItemsEvent(),
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
    await payment(response.paymentId ?? '');
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

  void initializeProductCounts(GetCartItemsModel? getCartItemsModel) {
    if (getCartItemsModel?.data != null) {
      subtotal = 0;
      for (var item in getCartItemsModel!.data!) {
        setState(() {
          subtotal += item.totalPrice ?? 0; // Initialize subtotal from API response
          total = subtotal;
        });
      }
    }
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
          "Shopping Cart",
          style: AppStyles.black_24_w300,
        ),
      ),
      body: BlocConsumer<GetCartItemsBloc, GetCartItemsState>(
        listener: (context, state) {
          if (state.isCompleted) {
            initializeProductCounts(state.getCartItemsModel);
            if (widget.discount != 0 && widget.voucherCode != "") {
              calculateDiscountedPrice(subtotal.toDouble(), "${widget.discount}%");
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<GetAddressScreenBloc, GetAddressScreenState>(
            listener: (context, addressState) {
              if (addressState.isCompleted) {
                var addressList = addressState.getAllAddressModel?.data ?? [];
                if (addressList.isEmpty) {
                  logger.e("No default address found.");
                } else {
                  var defaultAddress = addressList.firstWhere(
                    (item) => item.isDefaultAddress == true,
                  );
                  if (defaultAddress != null) {
                    houseNo = '${defaultAddress.house}';
                    address = "${defaultAddress.landmark}, ${defaultAddress.area}, ${defaultAddress.city}, ${defaultAddress.pinCode}";
                  } else {
                    logger.e("No default address found.");
                  }
                }
              }
            },
            builder: (context, addressState) {
              return BlocConsumer<RemoveCartItemBloc, RemoveCartItemState>(
                listener: (context, removeState) {
                  if (removeState.isCompleted) {
                    AlertUtils.showToast("Item removed successfully.");
                    BlocProvider.of<GetCartItemsBloc>(context).add(
                      PerformGetCartItemsEvent(),
                    );
                  }
                },
                builder: (context, removeState) {
                  return BlocConsumer<OrderStickerBloc, OrderStickerState>(
                    listener: (context, orderState) {
                      if (orderState.isCompleted) {
                        AlertUtils.showToast("Order placed successfully.");
                        Navigator.pushNamed(
                          context,
                          AppScreens.orderHistoryScreen,
                            arguments: {
                              'fromDrawer':false
                            }
                        );
                      }
                    },
                    builder: (context, orderState) {
                      return BlocConsumer<UpdateCartQuantityBloc, UpdateCartQuantityState>(
                        listener: (context, quantityState) {
                          if (quantityState.isCompleted) {
                            BlocProvider.of<GetCartItemsBloc>(context).add(
                              PerformGetCartItemsEvent(),
                            );

                            AlertUtils.showToast(quantityState.updateCartQuantityModel?.message ?? '');
                          }
                        },
                        builder: (context, quantityState) {
                          return BlocConsumer<PaymentBloc, PaymentState>(
                            listener: (context, paymentState) async {
                              if (paymentState.isCompleted) {
                                await completeOrder(paymentState.paymentModel?.data?.sId ?? '', paymentState.paymentModel?.data?.transectionId ?? '',
                                    widget.discount, widget.voucherCode);
                              }
                            },
                            builder: (context, paymentState) {
                              return Stack(
                                children: [
                                  paymentState.isLoading ||
                                          state.isLoading ||
                                          addressState.isLoading ||
                                          removeState.isLoading ||
                                          orderState.isLoading ||
                                          orderState.isLoading
                                      ? LoaderWidget()
                                      : SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: state.getCartItemsModel?.data?.length ?? 0,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      // subtotal = 0;
                                                      // for (int ind = 0; ind < (state.getCartItemsModel?.data?.length ?? 0); ind++) {
                                                      //   subtotal += state.getCartItemsModel?.data?[ind].totalPrice ?? 0;
                                                      // }
                                                      // logger.wtf("THIS IS YOUR SUBTOTAL==> $subtotal");
                                                      productCounts[index] ??= state.getCartItemsModel?.data?[index].quantity ?? 1;

                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                                        child: Card(
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 175.h,
                                                                  width: 110.w,
                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                                                  child: state.getCartItemsModel?.data?[index].productDetails?.image != ""
                                                                      ? CachedNetworkImage(
                                                                          height: MediaQuery.of(context).size.height / 2.3,
                                                                          imageUrl:
                                                                              "${APIConstants.imageUrl}${state.getCartItemsModel?.data?[index].productDetails?.image ?? ""}",
                                                                          fit: BoxFit.fill,
                                                                          width: double.infinity,
                                                                          progressIndicatorBuilder: (context, url, progress) => Center(
                                                                            child: CircularProgressIndicator(
                                                                              value: progress.progress,
                                                                              color: AppStyles.primary,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Image.asset(
                                                                          ImageAssetPath.productDetailsImage,
                                                                          fit: BoxFit.fill,
                                                                          width: double.infinity,
                                                                          errorBuilder: (context, error, stackTrace) {
                                                                            return const Icon(
                                                                              Icons.error,
                                                                              color: Colors.red,
                                                                            );
                                                                          },
                                                                        ),
                                                                ),
                                                                SizedBox(
                                                                  width: 18.w,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        // mainAxisAlignment: MainAxisAlignment.end,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              state.getCartItemsModel?.data?[index].productDetails?.productName ?? '',
                                                                              style: AppStyles.black_14_w500
                                                                                  .copyWith(fontSize: 18.sp, overflow: TextOverflow.ellipsis),
                                                                              maxLines: 3,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 2.w),
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                _showConfirmationDialog(
                                                                                    state.getCartItemsModel?.data?[index].sId ?? '');
                                                                              },
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6.h,
                                                                      ),
                                                                      Text(
                                                                        state.getCartItemsModel?.data?[index].productDetails?.description ?? '',
                                                                        style: AppStyles.hintText_15_w400,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 5,
                                                                      ),
                                                                      SizedBox(
                                                                        height: 6.h,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            'Rs ${state.getCartItemsModel?.data?[index].totalPrice.toString() ?? ''}/-',
                                                                            //"Rs ${(state.getCartItemsModel?.data?[index].pricePerItem != 0 ? (state.getCartItemsModel?.data![index].pricePerItem ?? 0 * productCounts[index]!).toStringAsFixed(0) : "0")}/-",
                                                                            style: AppStyles.black_17_w600.copyWith(
                                                                              color: AppStyles.black,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5.w,
                                                                          ),
                                                                          Expanded(
                                                                            child: Container(
                                                                              height: 35.h,
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(4),
                                                                                  border: Border.all(color: AppStyles.textFieldBorderColor)),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        if (productCounts[index]! > 1) {
                                                                                          // Use '!' to assert that it is not null
                                                                                          setState(() {
                                                                                            productCounts[index] = (productCounts[index] ?? 1) -
                                                                                                1; // Decrement the count
                                                                                            updateQuantity(
                                                                                                state.getCartItemsModel?.data?[index].sId, false);
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.remove,
                                                                                        size: 20.h,
                                                                                      ),
                                                                                    ),
                                                                                    Text("${productCounts[index]}", style: AppStyles.black_17_w600),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          productCounts[index] = (productCounts[index] ?? 0) + 1;
                                                                                          updateQuantity(
                                                                                              state.getCartItemsModel?.data?[index].sId, true);
                                                                                        });
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.add,
                                                                                        size: 20.h,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 40.h),
                                                  child: address == ""
                                                      ? Container(
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
                                                          height: 70.h,
                                                          width: double.infinity,
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Add delivery address",
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16.w,
                                                                  ),
                                                                  maxLines: 3,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                                SizedBox(
                                                                  width: 12.w,
                                                                ),
                                                                SizedBox(
                                                                  height: 40.h,
                                                                  width: 125.w,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      Navigator.pushReplacementNamed(context, AppScreens.savedAddress, arguments: {
                                                                        'fromShopping': true,'fromDrawer': false
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      padding: EdgeInsets.zero,
                                                                      minimumSize: Size(95.w, 40.h),
                                                                      backgroundColor: AppStyles.white,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          side: BorderSide(color: AppStyles.primary)),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Add Address',
                                                                        style:
                                                                            AppStyles.white_16_w700.copyWith(color: AppStyles.primary, fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
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
                                                          height: 120.h,
                                                          width: double.infinity,
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    // mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        houseNo,
                                                                        style: TextStyle(
                                                                            color: Colors.black, fontSize: 18.w, fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          address,
                                                                          style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 16.w,
                                                                          ),
                                                                          maxLines: 3,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 12.w,
                                                                ),
                                                                SizedBox(
                                                                  height: 40.h,
                                                                  width: 95.w,
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      Navigator.pushReplacementNamed(context, AppScreens.savedAddress, arguments: {
                                                                        'fromShopping': true,'fromDrawer': false
                                                                      });
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      padding: EdgeInsets.zero,
                                                                      minimumSize: Size(95.w, 40.h),
                                                                      backgroundColor: AppStyles.white,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          side: BorderSide(color: AppStyles.primary)),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Change',
                                                                        style:
                                                                            AppStyles.white_16_w700.copyWith(color: AppStyles.primary, fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      AppScreens.voucherScreen,
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 55.h,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: AppStyles.lightPrimary,
                                                      borderRadius: BorderRadius.circular(4),
                                                      border: Border.all(color: Colors.grey, width: 0.8),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            widget.discount != 0 && widget.voucherCode != '' ? widget.voucherCode : "Have a Voucher?",
                                                            style: TextStyle(color: Colors.black, fontSize: 20.w),
                                                          ),
                                                          Icon(
                                                            Icons.keyboard_arrow_right,
                                                            size: 32.w,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Subtotal",
                                                      style: TextStyle(color: Colors.grey, fontSize: 18.w, fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "Rs ${subtotal}/-",
                                                      style: TextStyle(color: Colors.black, fontSize: 18.w, fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Shipping Charges",
                                                        style: TextStyle(color: Colors.grey, fontSize: 18.w, fontWeight: FontWeight.w500),
                                                      ),
                                                      Text(
                                                        "Free",
                                                        style: TextStyle(color: Colors.black, fontSize: 18.w, fontWeight: FontWeight.bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Discount",
                                                          style: TextStyle(color: Colors.grey, fontSize: 18.w, fontWeight: FontWeight.w500),
                                                        ),
                                                        Text(
                                                          '- ${discountAmount.toStringAsFixed(0)}/-',
                                                          style: TextStyle(color: Colors.black, fontSize: 18.w, fontWeight: FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  visible: widget.discount != 0 && widget.voucherCode != '',
                                                ),
                                                Divider(),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Total",
                                                      style: TextStyle(color: Colors.grey, fontSize: 18.w, fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      "Rs ${total}/-",
                                                      style: TextStyle(color: Colors.black, fontSize: 18.w, fontWeight: FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 30.h),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: 55.h,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (state.getCartItemsModel?.data?.length == 0) {
                                                          AlertUtils.showToast("Please select items for order.");
                                                        } else {
                                                          if (address == '') {
                                                            AlertUtils.showToast("Please add delivery address.");
                                                          } else {
                                                            openCheckout(total);
                                                          }
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppStyles.primary,
                                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Complete your Order',
                                                        style: AppStyles.white_16_w700,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  int calculateDiscountedPrice(double totalAmount, String discount) {
    // Remove '%' from the discount and convert it to a double
    double discountValue = double.parse(discount.replaceAll('%', ''));

    // Convert the percentage to a decimal (e.g., 20% -> 0.20)
    double discountDecimal = discountValue / 100;

    // Calculate the discount amount
    discountAmount = totalAmount * discountDecimal;

    // Subtract the discount from the total amount
    double finalAmount = totalAmount - discountAmount;
    total = finalAmount.toInt();
    return total;
  }

  _showConfirmationDialog(dynamic id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Confirm remove?',
            style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp),
          ),
          content: Text(
            'Are you sure you want to remove this item from cart?',
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
              onPressed: () async {
                Navigator.of(context).pop();
                await removeCartItem(id);
              },
              child: Text(
                'Remove',
                style: AppStyles.black_14_w500.copyWith(fontWeight: FontWeight.w600, color: AppStyles.primary),
              ),
            ),
          ],
        );
      },
    );
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

  Future<void> completeOrder(String paymentId, String transactionalId, int discount, String voucherCode) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      logger.w("voucher code  ==> ${voucherCode}");
      logger.w("discount  ==> ${discount}");
      logger.w("your res  ==> ${discount != 0 && voucherCode != ''}");
      var body = await discount != 0 && voucherCode != ''
          ? {"deliveryAddress": address, 'voucherCode': voucherCode, 'discount': discount, 'paymentId': paymentId, 'transectionId': transactionalId}
          : {"deliveryAddress": address, 'paymentId': paymentId, 'transectionId': transactionalId};

      BlocProvider.of<OrderStickerBloc>(context).add(
        PerformOrderStickerEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> removeCartItem(dynamic id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<RemoveCartItemBloc>(context).add(
        PerformRemoveCartItemEvent(id: id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> updateQuantity(dynamic id, bool isIncrease) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = isIncrease == true ? {"increase": true} : {"decrease": true};

      BlocProvider.of<UpdateCartQuantityBloc>(context).add(
        PerformUpdateCartQuantityEvent(id: id, data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
