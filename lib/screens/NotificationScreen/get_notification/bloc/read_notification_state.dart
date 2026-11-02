part of 'read_notification_bloc.dart';

@immutable

class ReadNotificationState {
  final bool isLoading;
  final bool isCompleted;
  final bool isFailed;
  final String? errorMsg;


  ReadNotificationState({
    this.isLoading = false,
    this.errorMsg,
    this.isCompleted = false,
    this.isFailed = false,
  });
}
