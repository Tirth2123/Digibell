import 'package:Digibells/screens/ProductDetailsScreen/add_to_cart/bloc/add_to_cart_bloc.dart';
import 'package:Digibells/screens/ProductDetailsScreen/add_to_cart/bloc/add_to_cart_event.dart';
import 'package:Digibells/screens/ProductDetailsScreen/add_to_cart/bloc/add_to_cart_state.dart';
import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/product_details_bloc.dart';
import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/product_details_state.dart';
import 'package:Digibells/utils/alert_utils.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../main.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';

class ProductDetailsScreen extends StatefulWidget {
  dynamic id;
  ProductDetailsScreen({super.key, required this.id});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductDetailsBloc>(create: (_) => ProductDetailsBloc()),
        BlocProvider<AddToCartBloc>(create: (_) => AddToCartBloc()),
      ],
      child: ProductDetailsScreen(
        id: 0,
      ),
    );
  }

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int productCount = 1;
  // final double pricePerItem = ;

  // final TextEditingController landmarkController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // FocusNode addressFocusNode = FocusNode();
  // bool addressValidate = false;
  // bool emptyaddressValidate = false;

  void initState() {
    BlocProvider.of<ProductDetailsBloc>(context).add(
      PerformProductDetailsEvent(id: widget.id),
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
          "Product Details",
          style: AppStyles.black_24_w300,
        ),
      ),
      body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        listener: (context, state) async {
          if (state.isCompleted) {}
        },
        builder: (context, state) {
          final items = state.productDetailsModel?.data;

          return BlocConsumer<AddToCartBloc, AddToCartState>(
            listener: (context, cartState) {
              if (cartState.isCompleted) {
                AlertUtils.showToast("Item added to cart successfully.");
                Navigator.pushNamed(context, AppScreens.shoppingCartScreen, arguments: {'voucherCode': '', 'discount': 0});
              }
            },
            builder: (context, cartState) {
              return Stack(
                children: [
                  state.isLoading || cartState.isLoading
                      ? LoaderWidget()
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h, bottom: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  height: MediaQuery.of(context).size.height / 2.3,
                                  imageUrl: "${APIConstants.imageUrl}${state.productDetailsModel?.data?.image ?? ""}",
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  progressIndicatorBuilder: (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                      color: AppStyles.primary,
                                    ),
                                  ),
                                ),
                                // Image.asset(
                                //   ImageAssetPath.productDetailsImage,
                                //   fit: BoxFit.fill,
                                //   width: double.infinity,
                                // ),
                                SizedBox(height: 50.h),
                                SizedBox(
                                  width: 300.w,
                                  child: Text(
                                    items?.productName ?? "",
                                    // "Qr Code with Sticker",
                                    style: AppStyles.black_14_w500.copyWith(fontSize: 18.sp, overflow: TextOverflow.ellipsis),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 48.h,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // "Rs 200/-",
                                            "Rs ${(items?.price != null ? (items!.price! * productCount).toStringAsFixed(0) : "0")}/-",
                                            style: AppStyles.black_17_w600.copyWith(
                                              color: AppStyles.blue,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          Text(
                                            "inclusive all taxes",
                                            style: AppStyles.hintText_15_w400.copyWith(fontSize: 11.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 48.h,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4), border: Border.all(color: AppStyles.textFieldBorderColor)),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (productCount != 1) {
                                                  setState(() {
                                                    productCount--;
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.remove,
                                                size: 20.h,
                                              ),
                                            ),
                                            Text("$productCount", style: AppStyles.black_17_w600),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  productCount++;
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
                                  ],
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                SizedBox(
                                  width: 330.w,
                                  child: Text(
                                    items?.description ?? "",
                                    style: AppStyles.hintText_15_w400,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 55.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (prefs?.getBool(AppConstants.guestLogin) == true) {
                                        AlertUtils.showGuestUserDialog(context);
                                      } else {
                                        int pricePerItem = (state.productDetailsModel?.data?.price ?? 0);
                                        addToCart(pricePerItem, productCount);
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
                                      'Add To Cart',
                                      style: AppStyles.white_16_w700,
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
      ),
    );
  }

  Future<void> addToCart(int price, int quantity) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {"productId": widget.id, "pricePerItem": price, "quantity": quantity};

      BlocProvider.of<AddToCartBloc>(context).add(
        PerformAddToCartEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  // void updateAddressSubmitButton(
  //     GetAllAddressModel stateA, String addressController) {
  //   if (stateA.data != null &&
  //       stateA.data!.isNotEmpty) {
  //     var address = stateA.data!.first;
  //     print("MY ADDRESS ==> ${addressController}");
  //     List<String> components = addressController.split(',');
  //     components = components.map((component) => component.trim()).toList();
  //     if (components.length >= 5) {
  //       String block = address.house ?? ''; // "Block ADc"
  //       String locality = address.landmark ?? ''; // "Bollywood"
  //       String landmark = address.area ?? '';// "Sete lights"
  //       String city = address.city ?? '';
  //       int pinCode = address.pinCode ?? 0;
  //
  //       var body = {
  //         "house": block,
  //         "landmark": locality,
  //         "area": landmark,
  //         "city": city,
  //         "pinCode": pinCode,
  //       };
  //       print("Updating Address with Body: $body");
  //
  //       BlocProvider.of<UpdateAddressBloc>(context).add(
  //         PerformUpdateAddressEvent(
  //             data: body, id: stateA.data?.first.sId.toString()),
  //       );
  //     } else {
  //       print("Address does not have the expected number of components.");
  //     }
  //   } else {
  //     // Handle the case where the address data is not available
  //     AlertUtils.showManuallyCloseDialogue(
  //         context, "Address data is not available.", 4, 'Oops!');
  //   }
  // }
}
