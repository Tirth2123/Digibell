part of 'socket_connect_bloc.dart';

@immutable
class SocketConnectState {
  final bool isLoading;
  final List<dynamic> members;
  final String? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final bool isMoreLoading;
  final bool sendTokenCompleted;
  final bool onActionButtonCompleted;
  final bool actionButtonCompleted;
  final bool inComingCall;
  final String inComingCallUserId;
  final String actionType;
  final String token;
  final bool isAvailable;
  final String channelName;
  final String callerName;
  final String type;
  final String? from;
  final String? callerId;
  final String? receiverId;
  final IncomeCallModel? inComingCallUserData;
  final bool checkAvalibleCompleted;
  final bool callAcceptedButton;
  final String callId;
  final int userCount;

  SocketConnectState({
    this.actionButtonCompleted = false,
    this.members = const [],
    this.callAcceptedButton = false,
    this.checkAvalibleCompleted = false,
    this.isAvailable = false,
    this.isLoading = false,
    this.isMoreLoading = false,
    this.onActionButtonCompleted = false,
    this.error,
    this.errorMsg = '',
    this.receiverId = '',
    this.callId = '',
    this.userCount = 0,
    this.callerId = '',
    this.type = '',
    this.actionType = '',
    this.callerName = '',
    this.channelName = '',
    this.inComingCallUserId = '',
    this.isCompleted = false,
    this.inComingCall = false,
    this.sendTokenCompleted = false,
    this.isFailed = false,
    this.inComingCallUserData,
    this.token = '',
    this.from,
  });
}
