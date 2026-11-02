abstract class DeclineInviteEvent {
  const DeclineInviteEvent();
}

class PerformDeclineInviteEvent extends DeclineInviteEvent {
  final dynamic id;

  PerformDeclineInviteEvent({required this.id});
}
