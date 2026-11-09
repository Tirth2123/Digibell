import 'dart:convert';
import 'dart:io';
import 'package:Digibells/firebase_notification/call_notification.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_screens/app_screens.dart';
import '../constants/app_constants.dart';
import '../main.dart';
import '../soketIO/model/incoming_call_model.dart';
import '../utils/logger.dart';

String callId1 = '';
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static bool _listenersInitialized = false; // Make this static to share across instances

  NotificationService() {
    _initializeFirebaseMessaging();
  }



  void _initializeFirebaseMessaging() async {
    if (_listenersInitialized) return;
    // Request permissions for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
     );

    // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      logger.i('User granted provisional permission');
    } else {
      logger.w('User declined or has not accepted permission');
    }


    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
     logger.i("IT'S HERE At BACKGROUND 12${message.data['title']}");
      logger.w("Local Notification = ${message.toMap()}");
      logger.w("Local Notification 11= ${message.data['title']}");
      //AlertUtils.showToast(message.data['title']);
      handleNotification(message);
     // _checkForInitialMessage();
    });

    // Handle notification taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.w("Notification opened = ${message.toMap()}");
      handleNotification(message);
     // _handleMessage(message);
    });


     _listenersInitialized = true; // Mark as initialized


  }

  // Future<void> _checkForInitialMessage() async {
  //   RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
  //   if (initialMessage != null) {
  //     logger.w("Initial message = ${initialMessage.toMap()}");
  //
  //    // _handleMessage(initialMessage);
  //   }
  // }

   @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     logger.i("IT'S HERE At BACKGROUND **${message.data['title']}");

    logger.w("ccc ${message.toMap()}");
    // Process the message in the background

        if (message.data['title'] == 'Incoming Voice Call...' || message.data['title'] == 'Incoming Video Call...') {
        logger.w("REDIRECT FROM background..");
        final data = json.decode(message.data['data']);
        //showIncomingCallNotification(message.data);

        if (data.containsKey('actionType')) {
          logger.i("IT'S HERE At BACKGROUND 1414${data['actionType']}");
          FlutterCallkitIncoming.endCall(callId1);
          logger.i("IT'S HERE At BACKGROUND 4${data['actionType']}");
          if(data['actionType'] == 'reject'){
            FlutterCallkitIncoming.endAllCalls();
            //logger.i("IT'S HERE At BACKGROUND 114 $callId1}");
            //FlutterCallkitIncoming.endCall(callId1);
          }else {
            logger.i("IT'S HERE At BACKGROUND 115 $callId1}");
            showIncomingCallNotification(message.data);
          }
        } else {
          logger.i("IT'S HERE At BACKGROUND 3${message.data}");
          showIncomingCallNotification(message.data);
        }

      } else {
        logger.i("IT'S HERE At BACKGROUND 1${message.data['title']}");
        return null;
      }
  }

    Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
  
  Future<void> handleNotification(dynamic message) async {

    if (message.data['title'] == 'Incoming Voice Call...' || message.data['title'] == 'Incoming Video Call...' ) {
    logger.w("REDIRECT FROM NOTTTTTTT..");
    Map<String, dynamic> jsonObject = jsonDecode(message.data['data']);
    IncomeCallModel callModel = IncomeCallModel.fromJson(jsonObject);

    try {
      logger.w("FROM NOTI. SERVICE....");

      await navigatorKey.currentState?.pushNamed(
        AppScreens.ringingScreen,
        arguments: {
          'userCount': callModel.userCount,
          'callId': callModel.callId,
          'members': callModel.members,
          'receiverId': callModel.receiverId,
          'type': callModel.type,
          'callerName': callModel.callerName,
          'token': callModel.token,
          'channelName': callModel.channelName,
          'callerId': callModel.callerId,
        },
      );
    } on Exception catch (e) {
      logger.e("ERROR FROM NOT SCREEN ==> $e");
    }
  }else{
      if (message.data['title'] != 'Incoming Voice Call...' || message.data['title'] != 'Incoming Video Call...' ) {
        // LocalNotificationService().showNotification(
        //   title: message.notification?.title ?? 'No Title',
        //   body: message.notification?.body ?? 'No Body',
        //   payload: jsonEncode(message.data),
        // );
      }
    }

  }
}

class PushNotificationService {
   FirebaseMessaging _fcm = FirebaseMessaging.instance;

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initialize() async {
   // Request permissions
   //  await _fcm.requestPermission(
   //    alert: true,
   //    announcement: false,
   //    badge: true,
   //    carPlay: false,
   //    criticalAlert: false,
   //    provisional: false,
   //    sound: true,
   //  );

    await getDeviceData();
  }

  Future getDeviceData() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String token = '';
    try {
      token = await _fcm.getToken() ?? '';
    } catch (e) {
      logger.w('Could not fetch FCM token immediately: $e');
    }
    String? voipToken;

    PackageInfo? packageInfo;
    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (e) {
      logger.w('PackageInfo error: $e');
    }

    String? osVersion;
    String? deviceCompany;
    String? model;
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        osVersion = build.version.sdkInt.toString();
        deviceCompany = '${build.manufacturer} - ${build.brand}';
        model = build.model;
        deviceId = build.id;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        osVersion = data.systemVersion;
        deviceCompany = 'Apple - ${data.utsname.machine.iOSProductName}';
        model = data.model;
        deviceId = data.identifierForVendor ?? 'ios-${DateTime.now().millisecondsSinceEpoch}';

        try {
          voipToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
          logger.i('Fetched VoIP PushKit Token: $voipToken');
        } catch (e) {
          logger.e('Failed to fetch VoIP PushKit token: $e');
        }
      }
    } catch (e) {
      logger.e('Failed to get platform device info: $e');
    }

    deviceId = deviceId ?? 'device-${DateTime.now().millisecondsSinceEpoch}';

    Map<String, dynamic> data = {
      "deviceId": deviceId,
      "fcmToken": token,
      "voipToken": voipToken ?? '',
      "deviceCompany": deviceCompany ?? 'Unknown',
      "deviceName": model ?? 'Mobile Device',
      "os": Platform.isAndroid ? 'android' : 'ios',
      "appVersion": packageInfo?.version.toString() ?? '1.0.0',
      "osVersion": osVersion ?? '1.0',
    };

    SharedPreferences pref = await SharedPreferences.getInstance();
    if (token.isNotEmpty) {
      await pref.setString(AppConstants.fcmToken, token);
    }
    if (voipToken != null && voipToken.isNotEmpty) {
      await pref.setString(AppConstants.voipToken, voipToken);
    }
    await pref.setString(AppConstants.deviceId, deviceId);
    String deviceData = jsonEncode(data);
    await pref.setString(AppConstants.deviceData, deviceData);
  }
  }
}
