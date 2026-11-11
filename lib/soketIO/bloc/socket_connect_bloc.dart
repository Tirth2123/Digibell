import 'dart:async';
import 'package:Digibells/soketIO/model/incoming_call_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../../../../constants/app_constants.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../main.dart';
import '../../utils/logger.dart';
import '../../utils/stream_builder.dart';

part 'socket_connect_event.dart';
part 'socket_connect_state.dart';

class SocketConnectBloc extends Bloc<SocketConnectEvent, SocketConnectState> {
  SocketConnectBloc() : super(SocketConnectState()) {
    on<PerformSocketConnectEvent>(_connectSocket);
    on<PerformLogout>(_logout);

    ///audio & video call
    on<PerformCheckAvalible>(_checkAvalible);
    on<PerformSendAgoraToken>(_sendAgoraToken);
    on<PerformOnRecivedInComingCall>(_onRecivedInComingCall);
    on<PerformCallAction>(_actionButton);
    on<PerformOnCallAction>(_onActionButton);
    on<PerformCallAccepted>(_callAcceptedButton);
    // on<PerformAddUserEvent>(_addUser);
  }

  void _connectSocket(PerformSocketConnectEvent event, Emitter<SocketConnectState> emit) async {
    emit(SocketConnectState(isLoading: true));

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
        emit(SocketConnectState(isLoading: false, isCompleted: true));
      } else {
        logger.d('SOCKET_IO true');
        emit(SocketConnectState(isLoading: false, isCompleted: true));
      }
    } catch (e) {
      logger.e('SOCKET IO CONNECT SOCKET ERROR ${e.toString()}');
      emit(SocketConnectState(isLoading: false, isFailed: true, errorMsg: '${e.toString()}'));
    }

    StreamUtil.socket.value.onConnect((data) {
      logger.i('SOCKET connected 1112, ${StreamUtil.socket.value.connected}');
      try {
        final uid = prefs.getString(AppConstants.userId);
        if (uid != null && uid.isNotEmpty) {
          StreamUtil.socket.value.emit("adduser", {'id': uid});
          // Self-heal: ensure server knows user is not in a call when connecting/reconnecting
          StreamUtil.socket.value.emit("clearmycall", {'userId': uid});
        } else {
          logger.e('ADD USER TIME USER ID NULL');
        }
      } catch (e) {
        logger.e('SOCKET IO ADDUSER ERROR ${e.toString()}');
      }
    });

    ///video call audio call
    StreamUtil.socket.value.on('receiveincomingcall', (data) async {
      logger.d('SOCKET API  receiveincomingcall  --------> $data');

      add(PerformOnRecivedInComingCall(
          callId: data['callId'],
          userCount: data['userCount'],
          channelName: data['channelName'],
          receiverId: data['receiverId'],
          token: data['token'],
          type: data['type'],
          callerName: data['callerName'],
          callerId: data['callerId']));



    });

    StreamUtil.socket.value.on('oncallaction', (data) async {
      logger.d('SOCKET API:- oncallaction   ------> $data');
      add(PerformOnCallAction(receiverId: data['data']['receiverId'], actionType: data['data']['actionType'], type: data['data']['type']));
    });


    StreamUtil.socket.value.on('callterminated', (data) async {
      logger.d('SOCKET API:- callterminated   ------> ${data['message']}');
      logger.d('this is terminated data ${data['message'] == 'Call has been terminated.'}');
      if(data['message']=='Call has been terminated.'){
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppScreens.firstTimeHomeScreen,(Route<dynamic> route) => false
        );
        StreamUtil.bottomNavigationIndex.add(0);
        await FlutterCallkitIncoming.endAllCalls();
      }
      // add(PerformCallTerminate(message: data['message'] ));
    });

  }

  void _logout(PerformLogout event, Emitter<SocketConnectState> emit) async {
    try {
      logger.d('socket call, socket is logout ${StreamUtil.socket.value.connected}');
      StreamUtil.socket.value.emit("removeuser", {'id': event.id});
      StreamUtil.socket.value.disconnect();
    } catch (e) {
      logger.e('SOCKET IO LOGOUT ERROR ${e.toString()}');
      emit(SocketConnectState(isFailed: true, errorMsg: '${e.toString()}'));
    }
  }

  ///audio call video call
  void _checkAvalible(PerformCheckAvalible event, Emitter<SocketConnectState> emit) async {
    //emit(SocketConnectState(isLoading: true));
    try {
      final completer = Completer();
      var senddata = {
        'userId': event.userId,
      };
      logger.d('SOCKET API:- userisincall');
      logger.d(senddata);
      StreamUtil.socket.value.emitWithAck("userisincall", senddata, ack: (data) {
        logger.d(data);
        completer.complete(data);
      });
      final data = await completer.future;
      emit(SocketConnectState(
        //isLoading: false,
          checkAvalibleCompleted: true,
          from: event.from,
          isAvailable: data['data']['isInCall']));
    } catch (e) {
      logger.e('SOCKET IO GET CREATE CHAT ERROR ${e.toString()}');

      emit(SocketConnectState(isFailed: true, checkAvalibleCompleted: true, error: '${e.toString()}'));
    }
  }

  void _sendAgoraToken(PerformSendAgoraToken event, Emitter<SocketConnectState> emit) async {
    //emit(SocketConnectState(isLoading: true));
    try {
      final completer = Completer();
      var senddata = {
        'receiverId': event.receiverId,
        'type': event.type,
        'callerName': event.callerName,
        'token': event.token,
        'callerId': event.callerId,
        'channelName': '${event.channelName}',
      };
      logger.d("sendagoratoken 1---------> $senddata");
      StreamUtil.socket.value.emitWithAck("sendagoratoken", senddata, ack: (data) {
        logger.d('sendagoratoken 2--------->  $data');
        completer.complete(data);
      });

      final data = await completer.future;

      StreamUtil.socket.value.emit('incomingcall', {"data": data});
      logger.d('incomingcall --------->  ${data['data']['rtcToken']}');
      emit(SocketConnectState(sendTokenCompleted: true, token: data['data']['rtcToken'], channelName: data['data']['channelName']));
    } catch (e) {
      logger.e('SOCKET IO GET CREATE CHAT ERROR ${e.toString()}');
      emit(SocketConnectState(isFailed: true, checkAvalibleCompleted: true, error: '${e.toString()}'));
    }
  }

  void _onRecivedInComingCall(PerformOnRecivedInComingCall event, Emitter<SocketConnectState> emit) async {
    logger.d('_onRecivedInComingCall STEP 1');
    try {
      logger.d('_onRecivedInComingCall STEP 2');
      emit(SocketConnectState(
        callerName: event.callerName ?? '',
        type: event.type ?? '',
        inComingCall: true,
        inComingCallUserId: event.receiverId ?? '',
        token: event.token ?? '',
        channelName: event.channelName ?? '',
        callerId: event.callerId ?? '',
      ));
      // await navigatorKey.currentState?.pushNamed(
      //   AppScreens.ringingScreen,
      //   arguments: {
      //     'members': data['members'],
      //     'receiverId': data['receiverId'],
      //     'type': data['type'],
      //     'callerName': data['callerName'],
      //     'token': data['type'],
      //     'channelName': data['channelName'],
      //     'callerId': data['callerId'],
      //   },
      // );
    } catch (e) {
      logger.e('SOCKET IO ERROR ${e.toString()}');
      emit(SocketConnectState(isFailed: true, error: '${e.toString()}'));
    }
  }

  void _actionButton(PerformCallAction event, Emitter<SocketConnectState> emit) async {
    //emit(SocketConnectState(isLoading: true));
    try {
      final completer = Completer();
      var senddata = {
        'members': event.members,
        'callId': event.callId,
        'userCount': event.userCount,
        'callerName': event.callerName,
        'type': event.type,
        'actionType': event.actionType,
        'token': event.token,
        'receiverId': event.receiverId,
        'callerId': event.callerId,
        'channelName': '${event.channelName}',
      };
      logger.d('SOCKET API:- $senddata');

      StreamUtil.socket.value.emitWithAck("callaction", senddata, ack: (data) {
        logger.d('callaction  ---------> $data');
        completer.complete(data);
      });

      final data = await completer.future;
      StreamUtil.socket.value.emit('callactionresponse', {"data": data});
      emit(SocketConnectState(
        actionType: event.actionType,
        callerName: event.callerName,
        callId: event.callId,
        userCount: event.userCount,
        actionButtonCompleted: true,
        type: event.type,
        token: event.token,
        receiverId: event.receiverId,
        callerId: event.callerId,
        channelName: event.channelName,
      ));
    } catch (e) {
      logger.e('SOCKET IO ERROR ${e.toString()}');

      emit(SocketConnectState(isFailed: true, actionButtonCompleted: true, error: '${e.toString()}'));
    }
  }

  void _callAcceptedButton(PerformCallAccepted event, Emitter<SocketConnectState> emit) async {
    try {
      var senddata = {
        'callerName': event.callerName,
        'type': event.type,
        'members': event.members,
        'token': event.token,
        'receiverId': event.receiverId,
        'callerId': event.callerId,
        'channelName': '${event.channelName}',
      };

      // callaccepted ==> fire-and-forget to notify server + other members
      StreamUtil.socket.value.emit(
        "callaccepted",
        senddata,
      );

      emit(SocketConnectState(
        members: event.members,
        callerName: event.callerName,
        callAcceptedButton: true,
        type: event.type,
        token: event.token,
        receiverId: event.receiverId,
        callerId: event.callerId,
        channelName: event.channelName,
      ));
    } catch (e) {
      logger.e('SOCKET IO ERROR ${e.toString()}');
      emit(SocketConnectState(isFailed: true, callAcceptedButton: true, error: '${e.toString()}'));
    }
  }

  void _onActionButton(PerformOnCallAction event, Emitter<SocketConnectState> emit) async {
    logger.d('_onActionButton triggered with actionType: ${event.actionType}');

    try {
      emit(SocketConnectState(
        onActionButtonCompleted: true,
        actionType: event.actionType, // This can be 'reject' or other types
        type: event.type,
      ));

      // Additional debug logging for 'reject' action handling
      if (event.actionType == 'reject') {
        logger.w("Received 'reject' action - navigating to home.");
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
            AppScreens.firstTimeHomeScreen,(Route<dynamic> route) => false
        );
        StreamUtil.bottomNavigationIndex.add(0);
      }
    } catch (e) {
      logger.e('SOCKET IO ADDUSER ERROR: ${e.toString()}');
      emit(SocketConnectState(isFailed: true, error: '${e.toString()}'));
    }
  }
}
