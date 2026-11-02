// @immutable
// abstract class ActivateQRCodeScreenEvent {}

abstract class ActivateQRCodeEvent {
  const ActivateQRCodeEvent();
}

class PerformActivateQRCodeEvent extends ActivateQRCodeEvent {
  final dynamic data;

  PerformActivateQRCodeEvent({required this.data});
}
