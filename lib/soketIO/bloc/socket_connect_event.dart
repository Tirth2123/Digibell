part of 'socket_connect_bloc.dart';

abstract class SocketConnectEvent {}

class PerformSocketConnectEvent extends SocketConnectEvent {
  PerformSocketConnectEvent();
}

class PerformLogout extends SocketConnectEvent {
  String id;

  PerformLogout({required this.id});
}

///audio video call
class PerformCheckAvalible extends SocketConnectEvent {
  String userId;
  String from;

  PerformCheckAvalible({
    required this.userId,
    required this.from,
  });
}

class PerformSendAgoraToken extends SocketConnectEvent {
  String receiverId;
  String type;
  String callerName;
  String token;
  String channelName;
  String callerId;

  PerformSendAgoraToken({
    required this.receiverId,
    required this.type,
    required this.token,
    required this.callerName,
    required this.callerId,
    required this.channelName,
  });
}

class PerformOnRecivedInComingCall extends SocketConnectEvent {
  String? receiverId;
  String? type;
  String? callerName;
  String? token;
  String? channelName;
  String? callerId;
  String? callId;
  int? userCount;

  PerformOnRecivedInComingCall({
    required this.receiverId,
    required this.type,
    required this.callerName,
    required this.callerId,
    required this.token,
    required this.channelName,
    required this.callId,
    required this.userCount,
  });
}

class PerformAddUserEvent extends SocketConnectEvent {
  String userId;

  PerformAddUserEvent({
    required this.userId,
  });
}

class PerformCallAction extends SocketConnectEvent {
  String receiverId;
  String channelName;
  String token;
  String type;
  String callerName;
  String callerId;
  String actionType;
  String callId;
  int userCount;
  List<dynamic> members;

  PerformCallAction({
    required this.userCount,
    required this.callId,
    required this.members,
    required this.receiverId,
    required this.actionType,
    required this.channelName,
    required this.token,
    required this.type,
    required this.callerName,
    required this.callerId,
  });
}

class PerformCallAccepted extends SocketConnectEvent {
  String receiverId;
  String channelName;
  String token;
  String type;
  String callerName;
  String callerId;
  List<dynamic> members;

  PerformCallAccepted({
    required this.receiverId,
    required this.members,
    required this.channelName,
    required this.token,
    required this.type,
    required this.callerName,
    required this.callerId,
  });
}

class PerformOnCallAction extends SocketConnectEvent {
  String receiverId;
  String actionType;
  String type;

  PerformOnCallAction({
    required this.receiverId,
    required this.actionType,
    required this.type,
  });
}
