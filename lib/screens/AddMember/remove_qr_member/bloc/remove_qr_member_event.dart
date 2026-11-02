 
 abstract class RemoveQRMemberEvent {
  const RemoveQRMemberEvent();
}

class PerformRemoveQRMemberEvent extends RemoveQRMemberEvent {
  final dynamic data;
  final dynamic id;

  PerformRemoveQRMemberEvent({required this.data, required this.id});
}
