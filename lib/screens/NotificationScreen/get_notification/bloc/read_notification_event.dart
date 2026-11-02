part of 'read_notification_bloc.dart';

@immutable
abstract class ReadNotificationEvent {
  ReadNotificationEvent();
}

class PerformReadNotificationEvent extends ReadNotificationEvent {
  PerformReadNotificationEvent();
}