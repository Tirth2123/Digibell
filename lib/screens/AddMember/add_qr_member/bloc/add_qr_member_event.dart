 
 abstract class AddQRMemberEvent {
  const AddQRMemberEvent();
}

class PerformAddQRMemberEvent extends AddQRMemberEvent {
  final dynamic data;
  final dynamic id;

  PerformAddQRMemberEvent({required this.data, required this.id});
}
