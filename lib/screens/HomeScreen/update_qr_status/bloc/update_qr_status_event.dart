abstract class UpdateQRStatusEvent {
  const UpdateQRStatusEvent();
}

class PerformUpdateQRStatusEvent extends UpdateQRStatusEvent {
  final dynamic id;

  PerformUpdateQRStatusEvent({required this.id});
}
