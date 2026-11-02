
  abstract class DeleteAddressEvent {
  const DeleteAddressEvent();
}

class PerformDeleteAddressEvent extends DeleteAddressEvent {
   final dynamic id;

  PerformDeleteAddressEvent({ required this.id});
}
