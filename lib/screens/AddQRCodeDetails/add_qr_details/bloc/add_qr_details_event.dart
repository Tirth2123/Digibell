// @immutable
// abstract class AddQRDetailsScreenEvent {}

abstract class AddQRDetailsEvent {
  const AddQRDetailsEvent();
}

class PerformAddQRDetailsEvent extends AddQRDetailsEvent {
  final dynamic data;

  PerformAddQRDetailsEvent({required this.data});
}
