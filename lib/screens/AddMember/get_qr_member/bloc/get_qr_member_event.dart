 
 abstract class GetQRMemberEvent {
  const GetQRMemberEvent();
}

class PerformGetQRMemberEvent extends GetQRMemberEvent {

  final dynamic id;

  PerformGetQRMemberEvent({  required this.id});
}
