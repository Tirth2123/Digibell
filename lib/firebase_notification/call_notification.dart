import 'dart:async';
import 'dart:convert';
import 'package:Digibells/api_client/api_constans.dart';
import 'package:Digibells/constants/app_constants.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/utils/stream_builder.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


Timer? _callTimer;

/// Shows the native CallKit (iOS) / full-screen (Android) incoming call UI.
///
/// NOTE: CallKit event handling (accept / decline / timeout) is done
/// by the single global listener in main.dart — NOT here.
/// This function only displays the call and schedules auto-dismiss.
Future<void> showIncomingCallNotification(Map<String, dynamic> callData) async {

  try {
    // Decode the call data
    final data = json.decode(callData['data']);
    logger.w("THIS IS YOUR CALL DATA ==> ${callData}");
    logger.i("IT'S HERE At BACKGROUND 5${data['callId']}");

    // Prepare call kit parameters
    final callKitParams = CallKitParams(

      id: data['callerId'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nameCaller: data['callerName'].isNotEmpty ? data['callerName'] : 'Unknown Caller',
      appName: 'Digibell',
      type: data['type'] == 'audioCall' ? 0 : 1, // 0: audio, 1: video
      duration: 30000, // 30 seconds
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: callData,
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'ringtone', // Ensure ringtone file exists in res/raw
      ),
      ios: IOSParams(
        iconName: 'AppIcon',
        ringtonePath: 'ringtone.caf', // Ensure ringtone file exists
        supportsVideo: data['type'] != 'audioCall',
      ),
    );

    final callId = callKitParams.id;

     // Show incoming call notification
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);

    // Schedule auto-dismissal after 30 seconds
    _callTimer?.cancel(); // Cancel any previous timer
    _callTimer = Timer(const Duration(seconds: 30), () async {
      logger.w("Call timeout: No response in 30 seconds");
      await FlutterCallkitIncoming.endCall(callId!);
    });

  } catch (e) {
    logger.e("Error showing incoming call notification: $e");
  }
}

/// Connect socket from background (when app was killed/background and
/// a CallKit event fires). Used by main.dart's global CallKit listener.
Future<void> connectSocketFromBackground() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString(AppConstants.token);
  logger.d('Token is: $token,');
  try {
    IO.Socket socket = IO.io(
        APIConstants.socket,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNewConnection() // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setQuery({'token': token})
            .setExtraHeaders({
          'token': token,
        })
            .build());
    StreamUtil.socket.add(socket);
    logger.d('SocketStatus -->>>> ${StreamUtil.socket.value.connected}');
    if (StreamUtil.socket.value.connected == false) {
      logger.w('SOCKET_IO False 1');
      StreamUtil.socket.value.connect();
      logger.w('SOCKET_IO False 333');
    } else {
      logger.d('SOCKET_IO true');
    }
  } catch (e) {
    logger.e('SOCKET IO CONNECT SOCKET ERROR ${e.toString()}');
  }

  StreamUtil.socket.value.onConnect((data) {
    logger.i("IT'S HERE At BACKGROUND SOCKET connected, ${StreamUtil.socket.value.connected}");
    try {
      if (prefs.getString(AppConstants.userId) != '' || prefs.getString(AppConstants.userId) != null) {
        StreamUtil.socket.value.emit("adduser", {'id': prefs.getString(AppConstants.userId) ?? ''});
      } else {
        logger.e('ADD USER TIME USER ID NULL');
      }
    } catch (e) {
      logger.e('SOCKET IO ADDUSER ERROR ${e.toString()}');
    }
  });

}

/// Emit the reject/noResponse action via socket when declining from
/// CallKit (background or foreground). Called from main.dart's listener.
Future<void> emitCallActionViaSocket(Map<String, dynamic> decodedData, String actionType) async {
  try {
    // Ensure socket is connected
    if (!StreamUtil.socket.hasValue || !StreamUtil.socket.value.connected) {
      await connectSocketFromBackground();
      // Give socket time to connect
      await Future.delayed(const Duration(seconds: 2));
    }

    final completer = Completer();
    var senddata = {
      'members': decodedData['members'],
      'callId': decodedData['callId'],
      'userCount': decodedData['userCount'],
      'callerName': decodedData['callerName'],
      'type': decodedData['type'],
      'actionType': actionType,
      'token': decodedData['token'],
      'receiverId': decodedData['receiverId'],
      'callerId': decodedData['callerId'],
      'channelName': decodedData['channelName'],
    };
    logger.d('SOCKET API:- $senddata');

    StreamUtil.socket.value.emitWithAck("callaction", senddata, ack: (data) {
      logger.d('callaction  ---------> $data');
      completer.complete(data);
    });

    final data = await completer.future;
    StreamUtil.socket.value.emit('callactionresponse', {"data": data});

  } catch (e) {
    logger.e('SOCKET IO ERROR ${e.toString()}');
  }
}
