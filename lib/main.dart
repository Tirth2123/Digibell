import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: unused_import
import 'package:Digibells/firebase_notification/call_notification.dart';
import 'package:Digibells/firebase_notification/notification_service.dart';
import 'package:Digibells/screens/ActivateQrCode/activate_qr_code/bloc/activate_qr_code_bloc.dart';
import 'package:Digibells/screens/AddMember/add_member/bloc/add_member_bloc.dart';
import 'package:Digibells/screens/AddMember/add_qr_member/bloc/add_qr_member_bloc.dart';
import 'package:Digibells/screens/AddMember/get_all_members/bloc/get_all_members_bloc.dart';
import 'package:Digibells/screens/AddMember/get_qr_member/bloc/get_qr_member_bloc.dart';
import 'package:Digibells/screens/AddMember/remove_member/bloc/remove_member_bloc.dart';
import 'package:Digibells/screens/AddMember/remove_qr_member/bloc/remove_qr_member_bloc.dart';
import 'package:Digibells/screens/AddQRCodeDetails/add_qr_details/bloc/add_qr_details_bloc.dart';
import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/bloc/update_qr_details_bloc.dart';
import 'package:Digibells/screens/Address/AddAddress/bloc/add_address_bloc.dart';
import 'package:Digibells/screens/Address/delete_address/bloc/delete_address_bloc.dart';
import 'package:Digibells/screens/Address/get_address/bloc/get_address_bloc.dart';
import 'package:Digibells/screens/Address/set_default_address/bloc/set_default_address_bloc.dart';
import 'package:Digibells/screens/CallHistory/call_history/bloc/call_history_bloc.dart';
import 'package:Digibells/screens/HomeScreen/forcefully_update/bloc/forcefully_update_bloc.dart';
import 'package:Digibells/screens/HomeScreen/get_all_qr_details/bloc/get_all_qr_details_bloc.dart';
import 'package:Digibells/screens/HomeScreen/update_qr_status/bloc/update_qr_status_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/data_check/bloc/data_check_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/guest_user/guest_user_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/login/bloc/login_screen_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/send_firebase_otp/bloc/send_firebase_otp_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/send_otp/send_otp_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/social_login/bloc/social_login_bloc.dart';
import 'package:Digibells/screens/LoginScreen/reactivate_account/bloc/reactivate_account_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/accept_invite/bloc/accept_invite_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/decline_invite/bloc/decline_invite_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/get_notification_bloc.dart';
import 'package:Digibells/screens/Address/update_address/bloc/update_address_bloc.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/bloc/read_notification_bloc.dart';
import 'package:Digibells/screens/ProductDetailsScreen/add_to_cart/bloc/add_to_cart_bloc.dart';
import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/product_details_bloc.dart';
import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/purchse_order_bloc.dart';
import 'package:Digibells/screens/ProductList/bloc/product_list_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/bloc/delete_account/delete_account_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/bloc/update_profile/update_profile_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/bloc/upload_image/upload_image_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/contact_us/bloc/contact_us_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/help_faqs/bloc/help_faqs_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/logout/bloc/logout_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/modify_notification/bloc/modify_notification_bloc.dart';
import 'package:Digibells/screens/SingUP/bloc/register_bloc.dart';
import 'package:Digibells/screens/SingUP/bloc/user_details_bloc.dart';
import 'package:Digibells/screens/SubscriptionScreen/in_app_purchase/bloc/in_app_purchase_bloc.dart';
import 'package:Digibells/screens/SubscriptionScreen/subscription_details/bloc/subscription_details_bloc.dart';
import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/bloc/upgrade_plan_bloc.dart';
import 'package:Digibells/screens/ViewQRCode/get_my_order_details/bloc/get_my_order_details_bloc.dart';
import 'package:Digibells/screens/ViewQRCode/order_sticker/bloc/order_sticker_bloc.dart';
import 'package:Digibells/screens/no_internet_screen.dart';
import 'package:Digibells/screens/payment/bloc/payment_bloc.dart';
import 'package:Digibells/screens/shopping_cart/get_cart_items/bloc/get_cart_items_bloc.dart';
import 'package:Digibells/screens/shopping_cart/get_vouchers/bloc/get_vouchers_bloc.dart';
import 'package:Digibells/screens/shopping_cart/remove_cart_item/bloc/remove_cart_item_bloc.dart';
import 'package:Digibells/screens/shopping_cart/update_cart_quantity/bloc/update_cart_quantity_bloc.dart';
import 'package:Digibells/soketIO/bloc/socket_connect_bloc.dart';
import 'package:Digibells/utils/alert_utils.dart';
import 'package:Digibells/utils/app_dependencies.dart';
import 'package:Digibells/utils/app_routers.dart';
import 'package:Digibells/utils/app_utils.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/utils/stream_builder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_screens/app_screens.dart';
import 'firebase_options.dart';
import 'screens/LoginScreen/bloc/send_firebase_otp/bloc/verify_otp_bloc.dart';
import 'screens/splashScreen/splash_screen.dart';

SharedPreferences? prefs;
List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // Initialize SharedPreferences
  prefs = await SharedPreferences.getInstance();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    NotificationService();
    // LocalNotificationService();
    //  LocalNotificationService().initialize();
  } catch (e) {
    logger.e('Error initializing Firebase: $e');
  }
  setupDependencies();
  runApp(MyApp.create());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocketConnectBloc(),
        ),
      ],
      child: MyApp(),
    );
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  final AppRouter _router = AppRouter();
  static final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  OverlaySupportEntry? entry;
  CallEvent? lastCallEvent;
  StreamSubscription? _callKitSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity().then((val) async {

      //await FlutterCallkitIncoming.endAllCalls();
      await [Permission.microphone, Permission.camera].request();
      await socketConnect();

      // SINGLE global CallKit event listener — handles ALL call events
      // regardless of whether the app is foreground, background, or was killed.
      // No isAppInBackground guard — CallKit events must ALWAYS be processed.
      _callKitSubscription?.cancel(); // Prevent duplicate listeners
      _callKitSubscription = FlutterCallkitIncoming.onEvent.listen((event) async {
        if (event == null) {
          logger.e("Received null event.");
          return;
        }

        final callId = event.body['id'];
        var extraData = event.body['extra'] ?? {};

        // On incoming call, always ensure socket is connected
        if (event.event == Event.actionCallIncoming) {
          logger.i("CallKit actionCallIncoming — ensuring socket connection");
          if (!StreamUtil.socket.hasValue || !StreamUtil.socket.value.connected) {
            await connectSocketFromBackground();
          }
          return;
        }

        if (extraData.containsKey('data') && extraData['data'] != null) {
          try {
            final decodedData = json.decode(extraData['data']);

            logger.w("Received extra data: ${event.body['extra']}");
            logger.w("Decoded data In Main: $decodedData");

            if (callId != null) {
              switch (event.event) {
                case Event.actionCallAccept:
                  logger.w("Event.actionCallAccept called");
                  await _handleCallAccept(callId, decodedData, 'accept');
                  break;
                case Event.actionCallDecline:
                  logger.w("Event.actionCallDecline called");
                  await _handleCallEnd(callId, decodedData, 'reject');
                  break;
                case Event.actionCallEnded:
                  logger.w("Event.actionCallEnded called");
                  await _handleCallEnd(callId, decodedData, 'noResponse');
                  break;
                case Event.actionCallTimeout:
                  logger.w("Event.actionCallTimeout called");
                  await _handleCallEnd(callId, decodedData, 'noResponse');
                  break;
                default:
                  logger.w("Unhandled event: ${event.event}");
              }
            } else {
              logger.e("callId is null.");
            }
          } catch (e) {
            logger.e("Error decoding JSON data: $e");
          }
        } else {
          logger.e("extraData['data'] is null or missing.");
        }
      });
    });
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      StreamUtil.isAppInBackground.add(false);
      print("didChangeAppLifecycleState App is in foreground 🚀");
      // Reconnect socket if it was disconnected while in background
      socketConnect();
    } else if (state == AppLifecycleState.paused) {
      StreamUtil.isAppInBackground.add(true);
      print("didChangeAppLifecycleState App is in background ⏳ ${StreamUtil.isAppInBackground.value}");
    } else if (state == AppLifecycleState.detached) {
      print("didChangeAppLifecycleState App is terminated ❌");
    }
  }

  // void _handleCallAccept(Map<String, dynamic> decodedData) async {
  //  await navigatorKey.currentState?.pushNamed(
  //     AppScreens.ringingScreen,
  //     arguments: {
  //       'members': decodedData['members'],
  //       'receiverId': decodedData['receiverId'],
  //       'type': decodedData['type'],
  //       'callerName': decodedData['callerName'],
  //       'token': decodedData['token'],
  //       'channelName': decodedData['channelName'],
  //       'callerId': decodedData['callerId'],
  //     },
  //   );
  // }

  Future<void> _handleCallEnd(String callId, Map<String, dynamic> decodedData, String actionType) async {
    await FlutterCallkitIncoming.endCall(callId);
    if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected) {
      // Socket is already connected — use BLoC
      await _connectSocketAndPerformAction(decodedData, actionType);
    } else {
      // Socket not connected (background/killed) — use direct socket helper
      await emitCallActionViaSocket(decodedData, actionType);
    }
  }

  Future<void> _connectSocketAndPerformAction(Map<String, dynamic> decodedData, String actionType) async {
    BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
    BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAction(
      callId: decodedData['callId'],
      userCount: decodedData['userCount'],
      members: decodedData['members'],
      actionType: actionType,
      callerName: decodedData['callerName'],
      type: decodedData['type'],
      token: decodedData['token'],
      receiverId: decodedData['receiverId'],
      callerId: decodedData['callerId'],
      channelName: decodedData['channelName'],
    ));
  }

  Future<void> _callAcceptPerformAction(Map<String, dynamic> decodedData, String actionType) async {
    //BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
    BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAction(
      callId: decodedData['callId'],
      userCount: decodedData['userCount'],
      members: decodedData['members'],
      actionType: actionType,
      callerName: decodedData['callerName'],
      type: decodedData['type'],
      token: decodedData['token'],
      receiverId: decodedData['receiverId'],
      callerId: decodedData['callerId'],
      channelName: decodedData['channelName'],
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      logger.e(e.toString());
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    result = await connectivity.checkConnectivity();
    setState(() {
      connectionStatus = result;
    });
    if (entry != null) {
      entry?.dismiss();
    }
    if (result.contains(ConnectivityResult.none) || result.isEmpty) {
      entry = showOverlay((context, _) {
        return const NoInternetScreen();
      }, duration: const Duration(hours: 500000));
    }
  }

  Future<void> socketConnect() async {
    logger.w("Socket value ==> ${StreamUtil.socket.hasValue}");
    var internet = await AppUtils.checkInternet();
    if (internet) {
      if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected == false) {
        BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
        //Fluttertoast.showToast(msg: 'CHECK NAV 1...');
        //await checkNavigation();
      } else if (!StreamUtil.socket.hasValue) {
        // Handle the case where the socket hasn't been initialized yet
        BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
        // Fluttertoast.showToast(msg: 'CHECK NAV 2...');
        //await checkNavigation();
      }
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  // Future<void> checkNavigation() async {
  //   try {
  //     // Fetch active calls
  //     final initialCallEvents = await FlutterCallkitIncoming.activeCalls();
  //
  //     if (initialCallEvents != null && initialCallEvents.isNotEmpty) {
  //      // Fluttertoast.showToast(msg: 'Initial Call Events: ${initialCallEvents.runtimeType.toString()}');
  //       logger.d('Initial Call Events: $initialCallEvents');
  //       //Clipboard.setData(ClipboardData(text: initialCallEvents.toString()));
  //
  //       // Decode the JSON string
  //
  //       try {
  //         // Decode the JSON
  //         if(initialCallEvents is List){
  //           logger.d('Initial Call Events length: ${initialCallEvents.length}');
  //           //final Map<String, dynamic> callEvent = initialCallEvents.last;
  //           final Map callEvent = initialCallEvents.last.map(
  //                 (key, value) => MapEntry(key.toString(), value),
  //           );
  //
  //           logger.d('Initial Call Events 111: $callEvent');
  //
  //           final Map extra = callEvent['extra'].map(
  //                 (key, value) => MapEntry(key.toString(), value),
  //           );
  //
  //           logger.d('Initial Call Events extra: $extra');
  //
  //           final Map data = jsonDecode(extra['data']);
  //
  //           logger.d('Initial Call Events data: $data');
  //
  //           // Access specific keys
  //           final String callerName = data['callerName'] ?? 'Unknown';
  //           final String channelName = data['channelName'] ?? 'Unknown Channel';
  //           final String token = data['token'] ?? 'No Token';
  //
  //           // Print the parsed data
  //           // print('Caller Name: $callerName');
  //           // print('Channel Name: $channelName');
  //           // print('Token: $token');
  //
  //           incomingRedirection(data);
  //         }
  //       } catch (e) {
  //         //print('Error parsing JSON: $e');
  //       }
  //
  //
  //     } else {
  //       //print('No active calls found.');
  //     }
  //   } catch (e) {
  //    // print('Error fetching active calls: $e');
  //     //Fluttertoast.showToast(msg: 'Failed to fetch active calls.');
  //   }
  //
  //   /*for (var event in initialCallEvents) {
  //     // Validate each event
  //     if (event is Map<String, dynamic>) {
  //       await handleIncomingCall(event);
  //     } else {
  //       print('Unexpected event type: ${event.runtimeType}, Value: $event');
  //     }
  //   }*/
  // }

  // Future<void> incomingRedirection(Map data)async {
  //
  //   await navigatorKey.currentState?.pushNamed(
  //     AppScreens.ringingScreen,
  //     arguments: {
  //       'receiverId': data['receiverId'],
  //       'type': data['type'],
  //       'callerName': data['callerName'],
  //       'token': data['token'],
  //       'channelName': data['channelName'],
  //       'callerId': data['callerId'],
  //       'members': data['members'],
  //     },
  //   );
  // }

  Future<void> callAccepted(Map<String, dynamic> data) async {
    var internet = await AppUtils.checkInternet();
    if (internet) {
      BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAccepted(
        callerName: data['callerName'],
        type: data['type'],
        token: data['token'],
        receiverId: data['receiverId'],
        callerId: data['callerId'],
        channelName: data['channelName'],
        members: data['members'],
      ));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> _handleCallAccept(String callId, Map<String, dynamic> data, String actionType) async {
    await FlutterCallkitIncoming.endCall(callId);
    if (StreamUtil.socket.hasValue && !StreamUtil.socket.value.connected) {
      await _connectSocketAndPerformAction(data, actionType);
      await callAccepted(data);
      await navigateToCall(data);
    } else if (!StreamUtil.socket.hasValue) {
      await _connectSocketAndPerformAction(data, actionType);
      await callAccepted(data);
      await navigateToCall(data);
    }
    else {
      await _callAcceptPerformAction(data, actionType);
      await callAccepted(data);
      await navigateToCall(data);
    }
  }

  Future<void> navigateToCall(Map<String, dynamic> data) async {
    if (data['type'] == 'audioCall') {
      await navigatorKey.currentState?.pushNamed(
        AppScreens.audioCallScreen,
        arguments: {
          'members': data['members'],
          'callId': data['callId'],
          'userCount': data['userCount'],
          'token': data['token'],
          'receiverId': data['receiverId'],
          'channelName': data['channelName'],
          'callerId': data['callerId'],
          'callerName': data['callerName'],
        },
      );
    } else if (data['type'] == 'videoCall') {
      await navigatorKey.currentState?.pushNamed(
        AppScreens.videoCallScreen,
        arguments: {
          'members': data['members'],
          'userCount': data['userCount'],
          'callId': data['callId'],
          'token': data['token'],
          'receiverId': data['receiverId'],
          'channelName': data['channelName'],
          'callerId': data['callerId'],
          'callerName': data['callerName'],
        },
      );
    }
  }

  // Future<void> handleCallEvent(CallEvent event) async {
  //   if(event.body == null)return;
  //   final callId = event.body['id'];
  //
  //   final extraData = event.body['extra'];
  //   final decodedData = json.decode(extraData['data']) ;
  //   String channelName = decodedData['channelName'];
  //
  //   Future<void> callAccepted() async {
  //     var internet = await AppUtils.checkInternet();
  //     if (internet) {
  //       BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAccepted(
  //         callerName: decodedData['callerName'],
  //         type: decodedData['type'],
  //         token: decodedData['token'],
  //         receiverId: decodedData['receiverId'],
  //         callerId:decodedData['callerId'],
  //         channelName:decodedData['channelName'],
  //         members: decodedData['members'],
  //       ));
  //     } else {
  //       AlertUtils.showNotInternetDialogue(context);
  //     }
  //   }
  //
  //   Future<void> actionClick(String actionType) async {
  //     var internet = await AppUtils.checkInternet();
  //     if (internet) {
  //       BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAction(
  //         actionType: actionType,
  //         callerName: decodedData['callerName'],
  //         type: decodedData['type'],
  //         token: decodedData['token'],
  //         receiverId: decodedData['receiverId'],
  //         callerId: decodedData['callerId'],
  //         channelName: decodedData['channelName'],
  //       ));
  //     } else {
  //       AlertUtils.showNotInternetDialogue(context);
  //     }
  //   }
  //
  //   switch (event.event) {
  //     case Event.actionCallIncoming:
  //       logger.w("Notification tapped for call ID: $callId");
  //       // Handle notification tap
  //       logger.w("FROM action call incoming....");
  //       // navigatorKey.currentState?.pushNamed(
  //       //   AppScreens.ringingScreen,
  //       //   arguments: {
  //       //     'members': decodedData['members'],
  //       //     'receiverId': decodedData['receiverId'],
  //       //     'type': decodedData['type'],
  //       //     'callerName': decodedData['callerName'],
  //       //     'token': decodedData['token'],
  //       //     'channelName': decodedData['channelName'],
  //       //     'callerId': decodedData['callerId'],
  //       //   },
  //       // );
  //       break;
  //
  //     case Event.actionCallAccept:
  //       logger.w("Call accepted for call ID form main1: $callId");
  //       logger.w("Call accepted for call ID form main2: ${channelName}");
  //       if(channelName != ''){
  //         logger.w("FROM actionCallAccept BUT...");
  //         navigatorKey.currentState?.pushNamed(
  //           AppScreens.ringingScreen,
  //           arguments: {
  //             'members': decodedData['members'],
  //             'receiverId': decodedData['receiverId'],
  //             'type': decodedData['type'],
  //             'callerName': decodedData['callerName'],
  //             'token': decodedData['token'],
  //             'channelName': decodedData['channelName'],
  //             'callerId': decodedData['callerId'],
  //           },
  //         );
  //       }
  //       break;
  //
  //       // case Event.actionCallCustom:
  //       // logger.w("Call accepted for call ID form main3: $callId");
  //       // logger.w("Call accepted for call ID form main4: ${channelName}");
  //       // print("FROM actionCallAccept BUT...");
  //       // navigatorKey.currentState?.pushNamed(
  //       //   AppScreens.ringingScreen,
  //       //   arguments: {
  //       //     'members': decodedData['members'],
  //       //     'receiverId': decodedData['receiverId'],
  //       //     'type': decodedData['type'],
  //       //     'callerName': decodedData['callerName'],
  //       //     'token': decodedData['token'],
  //       //     'channelName': decodedData['channelName'],
  //       //     'callerId': decodedData['callerId'],
  //       //   },
  //       // );
  //       // Add your call acceptance logic
  //
  //       // if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected == false) {
  //       //   BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
  //       //   await callAccepted();
  //       //   await actionClick('accept');
  //       // } else if (!StreamUtil.socket.hasValue) {
  //       //   // Handle the case where the socket hasn't been initialized yet
  //       //   BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
  //       //   await  callAccepted();
  //       //   await actionClick('accept');
  //       // }
  //       //
  //       // if (decodedData['type'] == 'audioCall') {
  //       //   Navigator.of(context).pushReplacementNamed(
  //       //     AppScreens.audioCallScreen,
  //       //     arguments: {
  //       //       'token': decodedData['token'],
  //       //       'receiverId': decodedData['receiverId'],
  //       //       'channelName': decodedData['channelName'],
  //       //       'callerId': decodedData['callerId'],
  //       //       'callerName': decodedData['callerName'],
  //       //     },
  //       //   );
  //       // } else if (decodedData['type'] == 'videoCall') {
  //       //   Navigator.of(context).pushReplacementNamed(
  //       //     AppScreens.videoCallScreen,
  //       //     arguments: {
  //       //       'token': decodedData['token'],
  //       //       'receiverId': decodedData['receiverId'],
  //       //       'channelName': decodedData['channelName'],
  //       //       'callerId': decodedData['callerId'],
  //       //       'callerName': decodedData['callerName'],
  //       //     },
  //       //   );
  //       // }
  //       //break;
  //
  //     // case Event.actionCallDecline:
  //     //   logger.w("Call declined for call ID: $callId");
  //     //   // Add your call decline logic
  //     //   await FlutterCallkitIncoming.endCall(callId!);
  //     //   if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected == false) {
  //     //     BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
  //     //     await actionClick('reject');
  //     //   } else if (!StreamUtil.socket.hasValue) {
  //     //     // Handle the case where the socket hasn't been initialized yet
  //     //     BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
  //     //     await actionClick('reject');
  //     //   }
  //
  //       // Navigator.of(context).pushNamedAndRemoveUntil( AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
  //       // StreamUtil.bottomNavigationIndex.add(0);
  //      // break;
  //     //
  //     //
  //
  //     // case Event.actionCallTimeout:
  //     //   logger.w("Call timeout for call ID: $callId");
  //     // Handle timeout logic
  //     // await actionClick('noResponse');
  //     // await FlutterCallkitIncoming.showMissCallNotification(
  //     //   CallKitParams(
  //     //     id: callId,
  //     //     nameCaller: decodedData['callerName'].isNotEmpty ? decodedData['callerName'] : 'Unknown Caller',
  //     //     type: decodedData['type'] == 'audioCall' ? 0 : 1,
  //     //     missedCallNotification: NotificationParams(
  //     //       subtitle: 'Missed Call',
  //     //     ),
  //     //     extra: extraData,
  //     //   ),
  //     // );
  //     // break;
  //
  //     default:
  //       logger.w("Unhandled event: ${event.event}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<LogoutBloc>(create: (_) => LogoutBloc()),
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        BlocProvider<GuestUserBloc>(create: (_) => GuestUserBloc()),
        BlocProvider<SendFirebaseOtpBloc>(create: (_) => SendFirebaseOtpBloc()),
        BlocProvider<VerifyOtpBloc>(create: (_) => VerifyOtpBloc()),
        BlocProvider<RegisterBloc>(create: (_) => RegisterBloc()),
        BlocProvider<SocialLoginBloc>(create: (_) => SocialLoginBloc()),
        BlocProvider<DataCheckBloc>(create: (_) => DataCheckBloc()),
        BlocProvider<ReactivateAccountBloc>(create: (_) => ReactivateAccountBloc()),
        BlocProvider<UserDetailsBloc>(create: (_) => UserDetailsBloc()),
        BlocProvider<UpdateProfileBloc>(create: (_) => UpdateProfileBloc()),
        BlocProvider<DeleteAccountBloc>(create: (_) => DeleteAccountBloc()),
        BlocProvider<UploadImageBloc>(create: (_) => UploadImageBloc()),
        BlocProvider<AddAddressBloc>(create: (_) => AddAddressBloc()),
        BlocProvider<ProductListBloc>(create: (_) => ProductListBloc()),
        BlocProvider<ProductDetailsBloc>(create: (_) => ProductDetailsBloc()),
        BlocProvider<UpdateAddressBloc>(create: (_) => UpdateAddressBloc()),
        BlocProvider<PurchseOrderBloc>(create: (_) => PurchseOrderBloc()),
        BlocProvider<GetAddressScreenBloc>(create: (_) => GetAddressScreenBloc()),
        BlocProvider<DeleteAddressBloc>(create: (_) => DeleteAddressBloc()),
        BlocProvider<SetDefaultAddressBloc>(create: (_) => SetDefaultAddressBloc()),
        BlocProvider<AddQRDetailsBloc>(create: (_) => AddQRDetailsBloc()),
        BlocProvider<GetAllQRDetailsBloc>(create: (_) => GetAllQRDetailsBloc()),
        BlocProvider<CallHistoryBloc>(create: (_) => CallHistoryBloc()),
        BlocProvider<UpdateQRDetailsBloc>(create: (_) => UpdateQRDetailsBloc()),
        BlocProvider<UpdateQRStatusBloc>(create: (_) => UpdateQRStatusBloc()),
        BlocProvider<AddMemberBloc>(create: (_) => AddMemberBloc()),
        BlocProvider<GetAllMembersBloc>(create: (_) => GetAllMembersBloc()),
        BlocProvider<RemoveMemberBloc>(create: (_) => RemoveMemberBloc()),
        BlocProvider<SubscriptionDetailsBloc>(create: (_) => SubscriptionDetailsBloc()),
        BlocProvider<GetNotificationsBloc>(create: (_) => GetNotificationsBloc()),
        BlocProvider<AcceptInviteBloc>(create: (_) => AcceptInviteBloc()),
        BlocProvider<DeclineInviteBloc>(create: (_) => DeclineInviteBloc()),
        BlocProvider<OrderStickerBloc>(create: (_) => OrderStickerBloc()),
        BlocProvider<GetMyOrderBloc>(create: (_) => GetMyOrderBloc()),
        BlocProvider<AddToCartBloc>(create: (_) => AddToCartBloc()),
        BlocProvider<GetCartItemsBloc>(create: (_) => GetCartItemsBloc()),
        BlocProvider<ActivateQRCodeBloc>(create: (_) => ActivateQRCodeBloc()),
        BlocProvider<RemoveCartItemBloc>(create: (_) => RemoveCartItemBloc()),
        BlocProvider<UpdateCartQuantityBloc>(create: (_) => UpdateCartQuantityBloc()),
        BlocProvider<GetVouchersBloc>(create: (_) => GetVouchersBloc()),
        BlocProvider<ModifyNotificationBloc>(create: (_) => ModifyNotificationBloc()),
        BlocProvider<ContactUsBloc>(create: (_) => ContactUsBloc()),
        BlocProvider<ForcefullyUpdateBloc>(create: (_) => ForcefullyUpdateBloc()),
        BlocProvider<SocketConnectBloc>(create: (_) => SocketConnectBloc()),
        BlocProvider<HelpFaqsBloc>(create: (_) => HelpFaqsBloc()),
        BlocProvider<PaymentBloc>(create: (_) => PaymentBloc()),
        BlocProvider<UpgradePlanBloc>(create: (_) => UpgradePlanBloc()),
        BlocProvider<AddQRMemberBloc>(create: (_) => AddQRMemberBloc()),
        BlocProvider<RemoveQRMemberBloc>(create: (_) => RemoveQRMemberBloc()),
        BlocProvider<GetQRMemberBloc>(create: (_) => GetQRMemberBloc()),
        BlocProvider<InAppPurchaseBloc>(create: (_) => InAppPurchaseBloc()),
        BlocProvider<ReadNotificationBloc>(create: (_) => ReadNotificationBloc()),
        BlocProvider<SendOtpBloc>(create: (_) => SendOtpBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              builder: (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                final scale = mediaQueryData.textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.14);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: scale),
                  child: child!,
                );
              },
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Digibell',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: SplashScreen(),
              // home: const ThankYouPage(),
              onGenerateRoute: _router.getRoute,
              navigatorObservers: [_router.routeObserver]);
        },
      ),
    );
  }
}
// await navigatorKey.currentState?.pushNamed(
//   AppScreens.ringingScreen,
//   arguments: {
//     'receiverId': data['receiverId'],
//     'type': data['type'],
//     'callerName': data['callerName'],
//     'token': data['token'],
//     'channelName': data['channelName'],
//     'callerId': data['callerId'],
//     'members': data['members'],
//   },
// );

/*Future<void> checkNavigation() async {
    try {
      // Fetch active calls
      final initialCallEvents = await FlutterCallkitIncoming.activeCalls();

      if (initialCallEvents != null && initialCallEvents.isNotEmpty) {
        Fluttertoast.showToast(msg: 'Initial Call Events: ${initialCallEvents.runtimeType.toString()}');
        print('Initial Call Events: ${initialCallEvents.toString()}');

        for (var event in initialCallEvents) {
          // Validate each event
          if (event is Map<String, dynamic>) {
            await handleIncomingCall(event);
          } else {
            print('Unexpected event type: ${event.runtimeType}, Value: $event');
          }
        }
      } else {
        print('No active calls found.');
      }
    } catch (e) {
      print('Error fetching active calls: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch active calls.');
    }
  }

  Future<void> handleIncomingCall(Map<String, dynamic> callEvent) async {
    try {
      Fluttertoast.showToast(msg: 'Processing Call Event: ${callEvent.toString()}');
      print('Processing Call Event: ${callEvent.toString()}');

      // Check if the `title` matches expected values
      final title = callEvent['title'] as String?;
      if (title == "Incoming Voice Call..." || title == "Incoming Video Call...") {
        // Safely extract `extra`
        final extra = callEvent['extra'];
        if (extra is Map) {
          final dataRaw = extra['data'];
          Map<String, dynamic>? data;

          if (dataRaw is String) {
            // Parse `data` if it's a JSON string
            try {
              data = jsonDecode(dataRaw) as Map<String, dynamic>;
            } catch (e) {
              print('Failed to parse `data` JSON string: $e');
              Fluttertoast.showToast(msg: 'Error parsing call data.');
            }
          } else if (dataRaw is Map) {
            // Convert `_Map<Object?, Object?>` to `Map<String, dynamic>`
            data = dataRaw.map((key, value) => MapEntry(key.toString(), value));
          } else {
            print('Unexpected type for `data`: ${dataRaw.runtimeType}');
          }

          if (data != null) {
            // Navigate to the ringing screen
            try {
              Fluttertoast.showToast(msg: 'Navigating with data: $data');
              await navigatorKey.currentState?.pushNamed(
                AppScreens.ringingScreen,
                arguments: {
                  'receiverId': data['receiverId'],
                  'type': data['type'],
                  'callerName': data['callerName'],
                  'token': data['token'],
                  'channelName': data['channelName'],
                  'callerId': data['callerId'],
                  'members': data['members'],
                },
              );
            } catch (e) {
              print('Navigation error: $e');
              Fluttertoast.showToast(msg: 'Failed to navigate to ringing screen.');
            }
          } else {
            print('Data is null or invalid.');
            Fluttertoast.showToast(msg: 'Call data is invalid.');
          }
        } else {
          print('`extra` is null or not a valid Map.');
          Fluttertoast.showToast(msg: 'Invalid call event details.');
        }
      } else {
        print('Call event title does not match expected values.');
        Fluttertoast.showToast(msg: 'Unexpected call title: $title');
      }
    } catch (e) {
      print('Error handling call event: $e');
      Fluttertoast.showToast(msg: 'Error processing call event.');
    }
  }*/
