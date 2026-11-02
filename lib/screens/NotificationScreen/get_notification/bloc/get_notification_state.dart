import '../../../../api_models/api_error.dart';
import '../model/get_notification_model.dart';

class GetNotificationsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetNotificationsModel? getNotificationsModel;

  GetNotificationsState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.getNotificationsModel,
  });
}
