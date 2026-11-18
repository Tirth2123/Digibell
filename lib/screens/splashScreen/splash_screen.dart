import 'dart:convert';
import 'dart:io';
import 'package:Digibells/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../firebase_notification/notification_service.dart';
import '../../main.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import '../../soketIO/bloc/socket_connect_bloc.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';
import '../../utils/stream_builder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  String version = '';
  PushNotificationService _notificationService = PushNotificationService();

  Map? notificationData;
  String? activeCallKitId;
  bool fromNotification = false;

  void _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  Future<void> initValue() async {
    await checkNavigation();
    await checkUserLoginAndRedirection();
  }

  Future<void> checkUserLoginAndRedirection() async {
    if (mounted) {
      _notificationService.initialize();
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        // If main.dart already handled an incoming CallKit accept while splash was showing,
        // do NOT wipe the navigation stack with firstTimeHomeScreen!
        if (isCallScreenActive) {
          logger.i('SplashScreen: Call screen already active — skipping home navigation.');
          return;
        }
        // prefs?.clear();
        if (prefs?.getBool(AppConstants.guestLogin) == true) {
          prefs?.clear();
          Navigator.pushNamedAndRemoveUntil(context, AppScreens.loginScreen, (Route<dynamic> route) => false);
        } else if (prefs?.getString(AppConstants.deviceData) == null) {
          PushNotificationService().getDeviceData();
          if (prefs?.getBool(AppConstants.login) ?? false) {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
            if (fromNotification && notificationData != null) {
              incomingRedirection(notificationData!);
            }
          } else if (prefs?.getBool(AppConstants.register) ?? false) {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.singUpScreen, (Route<dynamic> route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.loginScreen, (Route<dynamic> route) => false);
          }
        } else {
          if (prefs?.getBool(AppConstants.login) ?? false) {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
            if (fromNotification && notificationData != null) {
              incomingRedirection(notificationData!);
            }
          } else if (prefs?.getBool(AppConstants.register) ?? false) {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.singUpScreen, (Route<dynamic> route) => false);
          } else {
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.loginScreen, (Route<dynamic> route) => false);
          }
        }
      });
    }
  }

  @override
  void initState() {
    _getVersion();
    initValue();
    super.initState();
  }

  Future<void> checkNavigation() async {
    try {
      // Fetch active calls
      final initialCallEvents = await FlutterCallkitIncoming.activeCalls();

      if (initialCallEvents != null && initialCallEvents.isNotEmpty) {
        logger.d('Initial Call Events: $initialCallEvents');

        try {
          if (initialCallEvents is List) {
            logger.d('Initial Call Events length: ${initialCallEvents.length}');
            final Map callEvent = initialCallEvents.last.map(
              (key, value) => MapEntry(key.toString(), value),
            );

            logger.d('Initial Call Events 111: $callEvent');

            // CRITICAL FOR iOS: PushKit wakes the app in the background while the phone
            // is STILL RINGING (before the user taps Accept). activeCalls() contains that
            // ringing call with isAccepted == false! NEVER auto-accept or endAllCalls() on
            // an unanswered ringing call — only redirect if the call was ACTUALLY accepted.
            final bool isAccepted = callEvent['isAccepted'] == true || callEvent['accepted'] == true;
            if (!isAccepted) {
              logger.i('SplashScreen: Active CallKit call is still ringing (not yet accepted) — skipping auto-redirect.');
              return;
            }

            activeCallKitId = callEvent['id']?.toString();
            final rawExtra = callEvent['extra'];
            final Map extra = rawExtra is Map
                ? rawExtra.map((key, value) => MapEntry(key.toString(), value))
                : {};

            logger.d('Initial Call Events extra: $extra');

            final rawData = extra['data'] ?? extra;
            final Map data = rawData is String
                ? jsonDecode(rawData)
                : (rawData is Map ? Map<String, dynamic>.from(rawData) : {});

            if (data.isEmpty || (data['channelName'] == null && data['token'] == null)) {
              logger.w('SplashScreen: Accepted call event missing channelName/token — skipping.');
              return;
            }

            logger.d('Initial Call Events data: $data');
            fromNotification = true;
            notificationData = data;
          }
        } catch (e) {
          print('Error parsing JSON: $e');
        }
      } else {
        print('No active calls found.');
      }
    } catch (e) {
      print('Error fetching active calls: $e');
    }
  }

  Future<void> incomingRedirection(Map data) async {
    if (isCallScreenActive) {
      logger.i('SplashScreen.incomingRedirection: Call screen already active — skipping.');
      return;
    }
    isCallScreenActive = true;

    if (Platform.isAndroid) {
      await FlutterCallkitIncoming.endAllCalls();
    } else if (Platform.isIOS && activeCallKitId != null && activeCallKitId!.isNotEmpty) {
      // Keep iOS CallKit AVAudioSession alive for Agora
      await FlutterCallkitIncoming.setCallConnected(activeCallKitId!);
    }

    if (!StreamUtil.socket.hasValue || !StreamUtil.socket.value.connected) {
      BlocProvider.of<SocketConnectBloc>(context).add(PerformSocketConnectEvent());
      final sw = Stopwatch()..start();
      while (sw.elapsedMilliseconds < 2500) {
        if (StreamUtil.socket.hasValue && StreamUtil.socket.value.connected) break;
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    await callAccepted(data);
    await actionClick('accept', data);
    if (data['type'] == 'audioCall') {
      await navigatorKey.currentState?.pushNamed(
        AppScreens.audioCallScreen,
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
  }

  Future<void> actionClick(String actionType, Map data) async {
    var internet = await AppUtils.checkInternet();
    if (internet) {
      BlocProvider.of<SocketConnectBloc>(context).add(PerformCallAction(
        callId: data['callId'],
        userCount: data['userCount'],
        members: data['members'],
        actionType: actionType,
        callerName: data['callerName'],
        type: data['type'],
        token: data['token'],
        receiverId: data['receiverId'],
        callerId: data['callerId'],
        channelName: data['channelName'],
      ));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> callAccepted(Map data) async {
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

  // Future<void> handleIncomingCall(Map<String, dynamic> callEvent) async {
  //   try {
  //    // Fluttertoast.showToast(msg: 'Processing Call Event: ${callEvent.toString()}');
  //     print('Processing Call Event: ${callEvent.toString()}');
  //
  //     // Check if the `title` matches expected values
  //     final title = callEvent['title'] as String?;
  //     if (title == "Incoming Voice Call..." || title == "Incoming Video Call...") {
  //       // Safely extract `extra`
  //       final extra = callEvent['extra'];
  //       if (extra is Map) {
  //         final dataRaw = extra['data'];
  //         Map<String, dynamic>? data;
  //
  //         if (dataRaw is String) {
  //           // Parse `data` if it's a JSON string
  //           try {
  //             data = jsonDecode(dataRaw) as Map<String, dynamic>;
  //           } catch (e) {
  //             print('Failed to parse `data` JSON string: $e');
  //             //Fluttertoast.showToast(msg: 'Error parsing call data.');
  //           }
  //         } else if (dataRaw is Map) {
  //           // Convert `_Map<Object?, Object?>` to `Map<String, dynamic>`
  //           data = dataRaw.map((key, value) => MapEntry(key.toString(), value));
  //         } else {
  //           print('Unexpected type for `data`: ${dataRaw.runtimeType}');
  //         }
  //
  //         if (data != null) {
  //           // Navigate to the ringing screen
  //           try {
  //            // Fluttertoast.showToast(msg: 'Navigating with data: $data');
  //             await navigatorKey.currentState?.pushNamed(
  //               AppScreens.ringingScreen,
  //               arguments: {
  //                 'receiverId': data['receiverId'],
  //                 'type': data['type'],
  //                 'callerName': data['callerName'],
  //                 'token': data['token'],
  //                 'channelName': data['channelName'],
  //                 'callerId': data['callerId'],
  //                 'members': data['members'],
  //               },
  //             );
  //           } catch (e) {
  //             print('Navigation error: $e');
  //             // Fluttertoast.showToast(msg: 'Failed to navigate to ringing screen.');
  //           }
  //         } else {
  //           print('Data is null or invalid.');
  //          // Fluttertoast.showToast(msg: 'Call data is invalid.');
  //         }
  //       } else {
  //         print('`extra` is null or not a valid Map.');
  //        // Fluttertoast.showToast(msg: 'Invalid call event details.');
  //       }
  //     } else {
  //       print('Call event title does not match expected values.');
  //     //  Fluttertoast.showToast(msg: 'Unexpected call title: $title');
  //     }
  //   } catch (e) {
  //     print('Error handling call event: $e');
  //    // Fluttertoast.showToast(msg: 'Error processing call event.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Image.asset("assets/gif/app_opening_gif.gif"),
            ),
          ),
          Positioned(bottom: 10, child: Text(version, style: TextStyle(fontSize: 13)))
        ],
      ),
    );
  }
}
