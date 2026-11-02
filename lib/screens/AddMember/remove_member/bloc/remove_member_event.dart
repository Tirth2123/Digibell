abstract class RemoveMemberEvent {
  const RemoveMemberEvent();
}

class PerformRemoveMemberEvent extends RemoveMemberEvent {
  final dynamic id;

  PerformRemoveMemberEvent({required this.id});
}
