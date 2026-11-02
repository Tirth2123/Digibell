abstract class UpdateQRDetailsEvent {
  const UpdateQRDetailsEvent();
}

class PerformUpdateQRDetailsEvent extends UpdateQRDetailsEvent {
  final dynamic data;
  final dynamic id;

  PerformUpdateQRDetailsEvent({required this.data, required this.id});
}
