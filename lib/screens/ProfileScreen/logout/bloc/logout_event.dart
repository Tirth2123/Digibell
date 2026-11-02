abstract class LogoutEvent {
  LogoutEvent();
}

class PerformLogoutEvent extends LogoutEvent {
  final dynamic data;
  PerformLogoutEvent({required this.data});
}
