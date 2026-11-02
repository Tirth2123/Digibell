part of 'update_address_bloc.dart';

@immutable
abstract class UpdateAddressEvent {
  const UpdateAddressEvent();
}

class PerformUpdateAddressEvent extends UpdateAddressEvent {
  final dynamic data;
  final dynamic id;

  PerformUpdateAddressEvent({required this.data, required this.id});
}
