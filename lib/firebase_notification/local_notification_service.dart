import 'dart:async';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../app_screens/app_screens.dart';
import '../main.dart';
import '../utils/logger.dart';


class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initialize() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon'); // Ensure this icon exists in res/drawable

    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          _onTapNotification(jsonDecode(details.payload!));
        } else {
          logger.w("Notification tapped but payload is null");
        }
      },

      onDidReceiveBackgroundNotificationResponse: (details) {
        if (details.payload != null) {
          _onTapNotification(jsonDecode(details.payload!));
        } else {
          logger.w("Background notification tapped but payload is null");
        }
      },
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      timeoutAfter: 30000, // Auto-dismiss after 30 seconds
      ongoing: true,
      visibility: NotificationVisibility.public,
    );

    final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformDetails,
      payload: payload,
    );

    Timer(const Duration(seconds: 30), () {
      _flutterLocalNotificationsPlugin.cancel(notificationId);
    });
  }

  Future<void> _onTapNotification(dynamic data) async {
    if (data == null || data['title'] == null) {
      logger.e("Tapped notification has null data or title");
      return;
    }

    logger.i("Notification tapped with title: ${data['title']}");

    if (data['title'] == 'Incoming Voice Call...' || data['title'] == 'Incoming Video Call...') {
      try {
        final Map<String, dynamic> jsonObject = jsonDecode(data['data']);
        logger.i("Parsed call data: $jsonObject");

        // Handle the notification tap (e.g., navigate to the ringing screen)
        await navigatorKey.currentState?.pushNamed(
          AppScreens.ringingScreen,
          arguments: {
            'userCount': jsonObject['userCount'],
            'callId': jsonObject['callId'],
            'members': jsonObject['members'],
            'receiverId': jsonObject['receiverId'],
            'type': jsonObject['type'],
            'callerName': jsonObject['callerName'],
            'token': jsonObject['token'],
            'channelName': jsonObject['channelName'],
            'callerId': jsonObject['callerId'],
          },
        );
      } catch (e) {
        logger.e("Error processing notification data: $e");
      }
    }
  }
}
