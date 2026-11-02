import 'dart:convert';
import 'dart:io';
import 'package:Digibells/api_client/api_constans.dart';
import 'package:Digibells/screens/HomeScreen/forcefully_update/bloc/forcefully_update_event.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_event.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../constants/asset_path.dart';
import '../../main.dart';
import '../../soketIO/bloc/socket_connect_bloc.dart';
import '../../soketIO/model/incoming_call_model.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/stream_builder.dart';
import '../HomeScreen/forcefully_update/bloc/forcefully_update_bloc.dart';
import '../HomeScreen/forcefully_update/bloc/forcefully_update_state.dart';
import '../HomeScreen/home_screen.dart';
import '../NotificationScreen/get_notification/bloc/get_notification_state.dart';
import '../ProductList/product_list_screen.dart';
import '../ProfileScreen/profile_screen.dart';
import '../SingUP/sing_up_screen.dart';
import '../SubscriptionScreen/subscription_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstTimeHomeScreen extends StatefulWidget {
  const FirstTimeHomeScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForcefullyUpdateBloc>(create: (_) => ForcefullyUpdateBloc()),
        BlocProvider<SocketConnectBloc>(create: (_) => SocketConnectBloc()),
        BlocProvider<GetNotificationsBloc>(create: (_) => GetNotificationsBloc()),
      ],
      child: HomeScreen(),
    );
  }

  @override
  State<FirstTimeHomeScreen> createState() => _FirstTimeHomeScreenState();
}

class _FirstTimeHomeScreenState extends State<FirstTimeHomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  String fullName = '';
  String firstName = '';
  List<String> nameParts = [];
  String version = '';

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    _getVersion();
    fullName = prefs?.getString(AppConstants.userName) ?? '';
    nameParts = fullName.split(' ');
    firstName = nameParts[0];
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    //socketConnect();
    BlocProvider.of<ForcefullyUpdateBloc>(context).add(
      PerformForcefullyUpdateEvent(),
    );

    BlocProvider.of<GetNotificationsBloc>(context).add(
      PerformGetNotificationsEvent(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    StreamUtil.socket.value.emit("removeuser", {'id': prefs?.getString(AppConstants.userId) ?? ''});
    StreamUtil.socket.value.disconnect();
  }

  bool isSelect = true;

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Hello ${firstName}!";
      case 1:
        return "Product List";
      case 2:
        return "Subscriptions";
      case 3:
        return "Your Profile";

      default:
        return "";
    }
  }

  Widget buildBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const ProductListScreen();
      case 2:
        return SubscriptionScreen(
          update: false,
          index: 0,
          qrId: '',
        );
      case 3:
        return const ProfileScreen();
      default:
        return const SingUpScreen();
    }
  }

  bool isVersionGreater(String backendVersion, String appVersion) {
    // Split the version strings into their components
    List<String> backendVersionParts = backendVersion.split('.');
    List<String> appVersionParts = appVersion.split('.');

    // Parse the components as integers for comparison
    for (int i = 0; i < backendVersionParts.length; i++) {
      int backendPart = int.parse(backendVersionParts[i]);
      int appPart = int.parse(appVersionParts[i]);

      // Compare major, minor, and patch versions
      if (backendPart > appPart) {
        return true; // Backend version is greater
      } else if (backendPart < appPart) {
        return false; // App version is greater, no need to update
      }
    }

    // If all parts are equal
    return false; // No update needed
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForcefullyUpdateBloc, ForcefullyUpdateState>(
      listener: (context, state) {
        if (state.isCompleted) {
          if (Platform.isAndroid) {
            if (isVersionGreater(state.forcefullyUpdateModel?.data?.android?.version ?? '', version)) {
              _showUpdateDialog(context, state.forcefullyUpdateModel?.data?.android?.version ?? "",
                  state.forcefullyUpdateModel?.data?.android?.forcefullyUpdate ?? false);
            }
          } else if (Platform.isIOS) {
            if (isVersionGreater(state.forcefullyUpdateModel?.data?.ios?.version ?? '', version)) {
              _showUpdateDialog(
                  context, state.forcefullyUpdateModel?.data?.ios?.version ?? "", state.forcefullyUpdateModel?.data?.ios?.forcefullyUpdate ?? false);
            }
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<SocketConnectBloc, SocketConnectState>(
          listener: (context, socketState) {
            if (socketState.inComingCall) {
              logger.w("Incoming call detected: ${socketState.inComingCallUserId}, Type: ${socketState.type}");
              if (socketState.receiverId == prefs?.getString(AppConstants.userId)) {
                logger.w("REDIRECT FROM FIRST TIME HOME 1");
                Navigator.of(context).pushNamed(
                  AppScreens.ringingScreen,
                  arguments: {
                    'members': socketState.inComingCallUserData?.members ?? [],
                    'receiverId': socketState.inComingCallUserData?.receiverId ?? '',
                    'type': socketState.inComingCallUserData?.type ?? '',
                    'callerName': socketState.inComingCallUserData?.callerName ?? '',
                    'token': socketState.inComingCallUserData?.token ?? '',
                    'channelName': socketState.inComingCallUserData?.channelName ?? '',
                    'callerId': socketState.inComingCallUserData?.callerId ?? '',
                    'callId': socketState.inComingCallUserData?.callId ?? '',
                    'userCount': socketState.inComingCallUserData?.userCount ?? '',
                  },
                );
              }
            }
            if (socketState.isFailed) {
              AlertUtils.showManuallyCloseDialogue(context, state.errorMsg!, 4, 'Oops!');
            }
          },
          builder: (context, socketState) {
            return StreamBuilder<int>(
                stream: StreamUtil.bottomNavigationIndex,
                builder: (context, snapshot) {
                  return BlocConsumer<GetNotificationsBloc, GetNotificationsState>(
                  listener: (context, state) {

                  },
                  builder: (context, notificationState) {
                    int notificationCount = notificationState.getNotificationsModel?.notificationCount ?? 0;
                    return Scaffold(
                    backgroundColor: AppStyles.white,
                    appBar: AppBar(
                      scrolledUnderElevation: 0.0,
                      backgroundColor: AppStyles.white,
                      elevation: 0.0,
                      title: Text(
                        getTitle(snapshot.data ?? 0),
                        // "Hello Jack!",
                        style: AppStyles.black_24_w300,
                      ),
                      centerTitle: true,
                      leading: Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              if (prefs?.getBool(AppConstants.guestLogin) == true) {
                                AlertUtils.showGuestUserDialog(context);
                              } else {
                                Scaffold.of(context).openDrawer();
                              }
                            },
                            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                          );
                        },
                      ),
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

                    //******************** Drawer
                    drawer: Drawer(
                      backgroundColor: AppStyles.primary,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 50.h, right: 20.w),
                        child: ListView(
                          // padding: EdgeInsets.zero,
                          children: <Widget>[
                            Container(
                              color: AppStyles.primary,
                              padding: EdgeInsets.only(
                                left: 20.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.0),
                                  Text(
                                    'Hi ${firstName}!',
                                    style: AppStyles.white_24_w400.copyWith(fontSize: 18.sp, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                            // ListTile(
                            //   leading:
                            //       SvgPicture.asset(ImageAssetPath.favouriteMemberSvg),
                            //   title: Text(
                            //     'Favourite Member',
                            //     style: AppStyles.white_15_w500,
                            //   ),
                            //   trailing: SvgPicture.asset(ImageAssetPath.drawerArrowSvg),
                            //   onTap: () {
                            //     Navigator.pushNamed(
                            //       context,
                            //       AppScreens.favouriteMemberScreen,
                            //     );
                            //   },
                            // ),
                            ListTile(
                              leading: SvgPicture.asset(ImageAssetPath.orderHistorySvg),
                              title: Text(
                                'Sticker Order History',
                                style: AppStyles.white_15_w500,
                              ),
                              trailing: SvgPicture.asset(ImageAssetPath.drawerArrowSvg),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  AppScreens.stickerOrderHistoryScreen,
                                );
                              },
                            ),
                            ListTile(
                              leading: SvgPicture.asset(ImageAssetPath.orderHistorySvg),
                              title: Text(
                                'Order History',
                                style: AppStyles.white_15_w500,
                              ),
                              trailing: SvgPicture.asset(ImageAssetPath.drawerArrowSvg),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppScreens.orderHistoryScreen, arguments: {'fromDrawer': true});
                              },
                            ),
                            ListTile(
                              leading: SvgPicture.asset(ImageAssetPath.addAddressesSvg),
                              title: Text(
                                'Saved Address',
                                style: AppStyles.white_15_w500,
                              ),
                              trailing: SvgPicture.asset(ImageAssetPath.drawerArrowSvg),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, AppScreens.savedAddress, arguments: {'fromShopping': false, 'fromDrawer': true});
                              },
                            ),
                            ListTile(
                              leading: SvgPicture.asset(ImageAssetPath.shopFromAmazonSvg),
                              title: Text(
                                'Shop from Digibells',
                                style: AppStyles.white_15_w500,
                              ),
                              trailing: SvgPicture.asset(ImageAssetPath.drawerArrowSvg),
                              onTap: () {
                                Navigator.pop(context);
                                StreamUtil.bottomNavigationIndex.add(1);
                              },
                            ),
                            ListTile(
                              leading: SvgPicture.asset(ImageAssetPath.shareDigiBellSvg),
                              title: Text(
                                'Share DigiBells',
                                style: AppStyles.white_15_w500,
                              ),
                              trailing: SvgPicture.asset(ImageAssetPath.drawerArrowSvg),
                              onTap: () {
                                Navigator.pop(context);
                                Share.share(
                                  Platform.isAndroid ? APIConstants.shareAndroid : APIConstants.shareIos,
                                  //subject: 'Flutter Tutorial',
                                  subject: 'Share DigiBells',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //*********************  bottomNavigationBar

                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      currentIndex: snapshot.data ?? 0 /*_selectedIndex*/,
                      iconSize: 30,
                      // onTap: (index) => setState(
                      //   () => _selectedPage = index,
                      // ),
                      onTap: (index) {
                        if (index == 3 && prefs?.getBool(AppConstants.guestLogin) == true) {
                          AlertUtils.showGuestUserDialog(context);
                        } else {
                          StreamUtil.bottomNavigationIndex.add(index);
                        }
                      } /*_onItemTapped*/,
                      selectedItemColor: AppStyles.primary,
                      unselectedItemColor: Colors.grey,
                      items: [
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(snapshot.data == 0 ? ImageAssetPath.fillHomeSvg : ImageAssetPath.homeSvg),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(snapshot.data == 1 ? ImageAssetPath.fillShopSvg : ImageAssetPath.shopSvg),
                          label: 'Shop',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(snapshot.data == 2 ? ImageAssetPath.fillPlansSvg : ImageAssetPath.plansSvg),
                          label: 'Plans',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(snapshot.data == 3 ? ImageAssetPath.fillProfileSvg : ImageAssetPath.profileSvg),
                          label: 'Profile',
                        ),
                      ],
                    ),

                    body: buildBody(snapshot.data ?? 0),
                  );
  },
);
                });
          },
        );
      },
    );
  }

  // Future<void> socketConnect() async {
  //   var internet = await AppUtils.checkInternet();
  //   if (internet) {
  //     if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected == false) {
  //       BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
  //       try {
  //         await checkNavigation(context);
  //       } on Exception catch (e) {
  //         logger.e("your error is 1==> $e");
  //       }
  //     } else if (!StreamUtil.socket.hasValue) {
  //       BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
  //       try {
  //         await checkNavigation(context);
  //       } on Exception catch (e) {
  //         logger.e("your error is 2==> $e");
  //       }
  //     }
  //   } else {
  //     AlertUtils.showNotInternetDialogue(context);
  //   }
  // }

  // Future<void> checkNavigation(BuildContext context) async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //      if (message.notification!.title!.trim() == 'Incoming Voice Call...' || message.notification!.title!.trim() == 'Incoming Video Call...') {
  //       Map<String, dynamic> jsonObject = jsonDecode(message.data['data']);
  //       IncomeCallModel callModel = IncomeCallModel.fromJson(jsonObject);
  //       logger.w("REDIRECT FROM FIRST TIME HOME 2");
  //         try {
  //          if(mounted){
  //            Navigator.of(context).pushNamed(
  //              AppScreens.ringingScreen,
  //              arguments: {
  //                'members': callModel.members,
  //                'receiverId': '${callModel.receiverId}',
  //                'type': callModel.type,
  //                'callerName': callModel.callerName,
  //                'token': callModel.token,
  //                'channelName': callModel.channelName,
  //                'callerId': callModel.callerId,
  //              },
  //            );
  //          }else{
  //            logger.e("Not mounted");
  //          }
  //         } on Exception catch (e) {
  //           logger.e("your error is 3==> $e");
  //         }
  //     }
  //   });
  // }

  void _showUpdateDialog(BuildContext context, String version, bool force) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: force == true ? false : true,
          child: AlertDialog(
            title: Center(child: Text('Version $version', style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                  child: Text('Kindly update the app for better experience.',
                      textAlign: TextAlign.center,
                      style: AppStyles.greyColor_12_w500.copyWith(
                        fontSize: 14.sp,
                      )),
                ),
                Divider()
              ],
            ),
            actionsPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            actions: force == true
                ? [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Center(
                        child: TextButton(
                          child: Text('Update',
                              style: AppStyles.white_15_w500.copyWith(
                                color: AppStyles.primary,
                              )),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              await launchUrl(Uri.parse(APIConstants.playStore));
                            } else if (Platform.isIOS) {
                              await launchUrl(Uri.parse(APIConstants.appStore));
                            }
                          },
                        ),
                      ),
                    ),
                  ]
                : [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text('No',
                                style: AppStyles.white_15_w500.copyWith(
                                  color: AppStyles.primary,
                                )),
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                            },
                          ),
                          Text("|"),
                          TextButton(
                            child: Text('Update',
                                style: AppStyles.white_15_w500.copyWith(
                                  color: AppStyles.primary,
                                )),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              if (Platform.isAndroid) {
                                await launchUrl(Uri.parse(APIConstants.playStore));
                              } else if (Platform.isIOS) {
                                await launchUrl(Uri.parse(APIConstants.appStore));
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
