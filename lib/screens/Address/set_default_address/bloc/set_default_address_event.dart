
  abstract class SetDefaultAddressEvent {
  const SetDefaultAddressEvent();
}

class PerformSetDefaultAddressEvent extends SetDefaultAddressEvent {
   final dynamic id;

  PerformSetDefaultAddressEvent({ required this.id});
}
