import 'dart:async';
import 'dart:io';
import 'package:Digibells/api_client/api_constans.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_event.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_state.dart';
import 'package:Digibells/screens/SubscriptionScreen/subscription_details/bloc/subscription_details_bloc.dart';
import 'package:Digibells/screens/SubscriptionScreen/subscription_details/bloc/subscription_details_event.dart';
import 'package:Digibells/screens/SubscriptionScreen/subscription_details/bloc/subscription_details_state.dart';
import 'package:Digibells/screens/SubscriptionScreen/subscription_details/model/subscription_details_model.dart';
import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/bloc/upgrade_plan_bloc.dart';
import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/bloc/upgrade_plan_event.dart';
import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/bloc/upgrade_plan_state.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../constants/asset_path.dart';
import '../../main.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/logger.dart';
import '../../utils/stream_builder.dart';
import '../payment/bloc/payment_bloc.dart';
import '../payment/bloc/payment_event.dart';
import '../payment/bloc/payment_state.dart';
import 'in_app_purchase/bloc/in_app_purchase_bloc.dart';
import 'in_app_purchase/bloc/in_app_purchase_state.dart';

class SubscriptionScreen extends StatefulWidget {
  bool update;
  int index;
  String qrId;

  SubscriptionScreen({super.key, required this.update, required this.index, required this.qrId});

  static Widget create(bool update, int index, String qrId) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SubscriptionDetailsBloc>(create: (_) => SubscriptionDetailsBloc()),
        BlocProvider<InAppPurchaseBloc>(create: (_) => InAppPurchaseBloc()),
        BlocProvider<UpgradePlanBloc>(create: (_) => UpgradePlanBloc()),
        BlocProvider<PaymentBloc>(create: (_) => PaymentBloc()),
        BlocProvider<GetNotificationsBloc>(create: (_) => GetNotificationsBloc()),
      ],
      child: SubscriptionScreen(
        index: index,
        update: update,
        qrId: qrId,
      ),
    );
  }

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  TextEditingController searchCtrl = TextEditingController();
  dynamic type;
  String subscriptionId = '';

  //IN APP PURCHASE
  var apple_id = "";
  var planId = "";
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _connectionSubscription;
  final List<String> _productLists = [
    'home_standard_plan',
    'home_advanced_plan',
    'home_premium_plan',
    'hotel_professional_plan',
    'hotel_professional_plus_plan',
    'car_elite_plan'
  ];
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  /// RazorPay
  Razorpay? razorpay;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    if (widget.update == true) {
      _tabController.index = widget.index;
    }
    type = _tabController.index == 0
        ? 'home'
        : _tabController.index == 1
            ? 'hotel'
            : 'car';
    BlocProvider.of<SubscriptionDetailsBloc>(context).add(
      PerformSubscriptionDetailsEvent(type: type, search: searchCtrl.text),
    );

    BlocProvider.of<GetNotificationsBloc>(context).add(
      PerformGetNotificationsEvent(),
    );

    /// RazorPay
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_connectionSubscription != null) {
      _connectionSubscription!.cancel();
      _connectionSubscription = null;
    }
    super.dispose();
  }

  //IN APP PURCHASE
  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _connectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: ${productItem?.transactionId}');
      inAppPurchase(
        purchaseToken: productItem?.purchaseToken ?? '',
      );
      print("IN APP PURCHASE paymentparams STATUS : ${productItem?.purchaseStateAndroid?.name} ${productItem?.transactionStateIOS?.name}");
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      AlertUtils.showToast("Payment Failed - ${purchaseError!.message!}");
    });
    await _getProduct();
  }

  Future<void> _getProduct() async {
    try {
      print('Fetching product IDs: $_productLists');
      List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(_productLists);

      if (items.isEmpty) {
        print('No products found. Verify product IDs and store configurations.');
        // ToastUtils.showCustomToast(context, "No anything found.");
      } else {
        print('Products fetched: ${items.length}');
        for (var item in items) {
          print('Product: ${item.toString()}');
        }
      }

      setState(() {
        _items = items;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _requestPurchase(String productId) async {
    try {
      await FlutterInappPurchase.instance.requestPurchase(productId);
    } catch (e) {
      print('Error requesting purchase: $e');
    }
  }

  Future _getPurchases() async {
    List<PurchasedItem>? items = await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items = await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  /// Razor Pay
  Future<void> openCheckout(int amount) async {
    var options = {
      "key": APIConstants.razorPay_ID,
      "amount": amount * 100, // Convert Paisa to Rupees
      'name': prefs?.getString(AppConstants.userName) ?? '',
      'send_sms_hash': true,
      "currency": "INR",
      'timeout': 360, // in seconds
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
    print('FAILED DATA ${response.toString()}');
  }

  /// Razor Pay
  void handlerExternalWallet(ExternalWalletResponse response) {
    AlertUtils.showToast("EXTERNAL_WALLET: ${response.walletName!}");
  }

  @override
  Widget build(BuildContext context) {
    return widget.update == true
        ? BlocConsumer<GetNotificationsBloc, GetNotificationsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, notificationState) {
          int notificationCount = notificationState.getNotificationsModel?.notificationCount ?? 0;
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: AppStyles.white,
              elevation: 0.0,
              title: Text(
                "Subscriptions",
                style: AppStyles.black_24_w300,
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              centerTitle: true,
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        color: AppStyles.primary,
                        size: 30.0,
                      ),
                      onPressed: () {
                        if (prefs?.getBool(AppConstants.guestLogin) == true) {
                          AlertUtils.showGuestUserDialog(context);
                        } else {
                          Navigator.pushNamed(
                            context,
                            AppScreens.notificationScreen,
                          );
                        }
                      },
                    ),
                    Positioned(
                      right: 10.0,
                      top: 10.0,
                      child: notificationCount == 0 ? Container(width: 0.0, height: 0.0,)
                          : Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                        child: Center(
                          child: Text(
                            notificationCount > 9 ? '9+': '${notificationCount}',
                            style: TextStyle(
                                fontSize: 8.0,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            backgroundColor: AppStyles.white,
            body: body(),
          );
  },
)
        : Scaffold(
            backgroundColor: AppStyles.white,
            body: body(),
          );
  }

  Widget body() {
    return BlocConsumer<SubscriptionDetailsBloc, SubscriptionDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, paymentState) {
            if (paymentState.isCompleted) {
              upgradePlan(paymentState.paymentModel?.data?.razorpayPaymentId ?? '');
            }
          },
          builder: (context, paymentState) {
            return BlocConsumer<InAppPurchaseBloc, InAppPurchaseState>(
              listener: (context, inAppPurchaseState) {
                if (inAppPurchaseState.isCompleted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
                  StreamUtil.bottomNavigationIndex.add(0);
                  AlertUtils.showToast("Plan upgraded successfully.");
                }
              },
              builder: (context, inAppPurchaseState) {
                return BlocConsumer<UpgradePlanBloc, UpgradePlanState>(
                  listener: (context, upgradeState) {
                    if (upgradeState.isCompleted) {
                      Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
                      StreamUtil.bottomNavigationIndex.add(0);
                      AlertUtils.showToast("Plan upgraded successfully.");
                    }
                  },
                  builder: (context, upgradeState) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
                          child: Column(
                            children: [
                              widget.update == true
                                  ? SizedBox()
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(11),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppStyles.bordercolor,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: TextField(
                                        controller: searchCtrl,
                                        cursorColor: AppStyles.black,
                                        onChanged: (value) {
                                          logger.w('Search value changed: $value');
                                          getSubscriptionDetails(search: value, type: type);
                                          //VendordataApi(searchVal: value, tag: '');
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Search',
                                          hintStyle: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500),
                                          suffixIcon: Icon(
                                            Icons.search_sharp,
                                            color: AppStyles.black,
                                            size: 20,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(11),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: AppStyles.white,
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 10.h,
                              ),
                              widget.update == true
                                  ? SizedBox()
                                  : Container(
                                      height: 60.h,
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 10.h),
                                      child: TabBar(
                                        onTap: (int index) {
                                          type = index == 0
                                              ? 'home'
                                              : index == 1
                                                  ? 'hotel'
                                                  : 'car';
                                          BlocProvider.of<SubscriptionDetailsBloc>(context).add(
                                            PerformSubscriptionDetailsEvent(type: type, search: searchCtrl.text),
                                          );
                                        },
                                        labelPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.0.h),
                                        controller: _tabController,
                                        dividerColor: Colors.transparent,
                                        indicator: BoxDecoration(
                                          color: AppStyles.activeTabColor,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        labelColor: AppStyles.white,
                                        unselectedLabelColor: AppStyles.primary,
                                        labelStyle: AppStyles.red_16_w300.copyWith(color: AppStyles.white, fontWeight: FontWeight.w500),
                                        unselectedLabelStyle: AppStyles.red_16_w300.copyWith(color: AppStyles.primary, fontWeight: FontWeight.w500),
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        automaticIndicatorColorAdjustment: true,
                                        tabs: [
                                          Tab(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppStyles.activeTabColor),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text('Home'),
                                              ),
                                            ),
                                          ),
                                          Tab(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppStyles.activeTabColor),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text('Hotel'),
                                              ),
                                            ),
                                          ),
                                          Tab(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: AppStyles.activeTabColor),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text('Car'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _tabController,
                                      children: [
                                        homeTab(context, state.subscriptionDetailsModel?.data),
                                        hotelTab(context, state.subscriptionDetailsModel?.data),
                                        carTab(context, state.subscriptionDetailsModel?.data),
                                      ],
                                    ),
                                    Visibility(
                                      child: LoaderWidget(),
                                      visible: state.isLoading,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          child: LoaderWidget(),
                          visible: upgradeState.isLoading || paymentState.isLoading,
                        )
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

  Future<void> upgradePlan(String paymentId) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {"razorpay_payment_id": paymentId, "qrId": widget.qrId, "paymentStatus": "SUCCESS", "subscriptionId": subscriptionId};

      BlocProvider.of<UpgradePlanBloc>(context).add(
        PerformUpgradePlanEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> inAppPurchase({required String purchaseToken}) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {"purchaseToken": purchaseToken, "qrId": widget.qrId, "paymentStatus": "SUCCESS", "subscriptionId": subscriptionId};

      BlocProvider.of<UpgradePlanBloc>(context).add(
        PerformUpgradePlanEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future getSubscriptionDetails({required String type, required String search}) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<SubscriptionDetailsBloc>(context).add(PerformSubscriptionDetailsEvent(type: type, search: search));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Widget homeTab(BuildContext context, List<SubscriptionList>? data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.update == true) {
                      subscriptionId = data?[index].sId ?? '';
                      if (Platform.isAndroid == true) {
                        openCheckout(data?[index].price ?? 0);
                      } else if (Platform.isIOS == true) {
                        String pId = data?[index].name == 'Standard'
                            ? 'home_standard_plan'
                            : data?[index].name == 'Advanced'
                                ? 'home_advanced_plan'
                                : 'home_premium_plan';
                        _requestPurchase(pId);
                      }
                    } else {}
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppStyles.white,
                      boxShadow: [BoxShadow(color: AppStyles.bordercolor, blurRadius: 10.0)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            color: AppStyles.primary,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssetPath.colorsHome,
                                  height: 35.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  data?[index].name ?? '',
                                  style: AppStyles.white_20_w600.copyWith(fontSize: 18.sp),
                                ),
                                Spacer(),
                                Text(
                                  "${data?[index].price ?? ''}/-",
                                  style: AppStyles.white_20_w600,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "No. of House Member :",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].members.toString() ?? '',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Unlimited call",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].unlimitedCall == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Two way Audio & Video",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].twoWayAudioVideoCall == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "QR Scan Alert",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].qrScanAlert == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Visitor History",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].visitorHistory == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Vistor Photo Capture",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].visitorPhotoCapture == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h)
              ],
            );
          }),
    );
  }

  Widget hotelTab(BuildContext context, List<SubscriptionList>? data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.update == true) {
                      subscriptionId = data?[index].sId ?? '';
                      if (Platform.isAndroid == true) {
                        openCheckout(data?[index].price ?? 0);
                      } else if (Platform.isIOS == true) {
                        String pId = data?[index].name == 'Professional' ? 'hotel_professional_plan' : 'hotel_professional_plus_plan';

                        _requestPurchase(pId);
                      }
                    } else {}
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppStyles.white,
                      boxShadow: [BoxShadow(color: AppStyles.bordercolor, blurRadius: 10.0)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            color: AppStyles.primary,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssetPath.hotelImage,
                                  height: 35.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  data?[index].name ?? '',
                                  style: AppStyles.white_20_w600.copyWith(fontSize: 18.sp),
                                ),
                                Spacer(),
                                Text(
                                  "${data?[index].price ?? ''}/-",
                                  style: AppStyles.white_20_w600,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "No. of House Member :",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].members.toString() ?? '',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Unlimited call",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].unlimitedCall == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Two way Audio & Video",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].twoWayAudioVideoCall == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "QR Scan Alert",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].qrScanAlert == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Visitor History",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].visitorHistory == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Vistor Photo Capture",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].visitorPhotoCapture == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h)
              ],
            );
          }),
    );
  }

  Widget carTab(BuildContext context, List<SubscriptionList>? data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.update == true) {
                      subscriptionId = data?[index].sId ?? '';
                      if (Platform.isAndroid == true) {
                        openCheckout(data?[index].price ?? 0);
                      } else if (Platform.isIOS == true) {
                        _requestPurchase('car_elite_plan');
                      }
                    } else {}
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppStyles.white,
                      boxShadow: [BoxShadow(color: AppStyles.bordercolor, blurRadius: 10.0)],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            color: AppStyles.primary,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 25.w, right: 25.w),
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageAssetPath.carImage,
                                  height: 35.h,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(
                                  data?[index].name ?? '',
                                  style: AppStyles.white_20_w600.copyWith(fontSize: 18.sp),
                                ),
                                Spacer(),
                                Text(
                                  "${data?[index].price ?? ''}/-",
                                  style: AppStyles.white_20_w600,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "No. of House Member :",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].members.toString() ?? '',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Unlimited call",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].unlimitedCall == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Two way Audio & Video",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].twoWayAudioVideoCall == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "QR Scan Alert",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].qrScanAlert == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Visitor History",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].visitorHistory == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppStyles.black,
                                    size: 5.sp,
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Text(
                                    "Vistor Photo Capture",
                                    style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w400, fontSize: 15.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    data?[index].visitorPhotoCapture == true ? 'Yes' : 'No',
                                    style: AppStyles.black_17_w600.copyWith(fontSize: 15.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h)
              ],
            );
          }),
    );
  }
}
