// @immutable
// abstract class AddMemberScreenEvent {}

abstract class AddMemberEvent {
  const AddMemberEvent();
}

class PerformAddMemberEvent extends AddMemberEvent {
  final dynamic data;

  PerformAddMemberEvent({required this.data});
}
