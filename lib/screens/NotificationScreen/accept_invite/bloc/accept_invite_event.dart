abstract class AcceptInviteEvent {
  const AcceptInviteEvent();
}

class PerformAcceptInviteEvent extends AcceptInviteEvent {
  final dynamic id;

  PerformAcceptInviteEvent({required this.id});
}
