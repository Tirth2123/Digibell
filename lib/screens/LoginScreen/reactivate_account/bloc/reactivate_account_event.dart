abstract class ReactivateAccountEvent {
  const ReactivateAccountEvent();
}

class PerformReactivateAccountEvent extends ReactivateAccountEvent {
  final dynamic data;

  PerformReactivateAccountEvent({required this.data});
}
