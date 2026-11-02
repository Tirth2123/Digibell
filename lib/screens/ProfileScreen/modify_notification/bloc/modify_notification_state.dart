import '../../../../api_models/api_error.dart';
import '../model/modify_notification_model.dart';

class ModifyNotificationState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final ModifyNotificationModel? modifyNotificationModel;

  ModifyNotificationState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.modifyNotificationModel,
  });
}
