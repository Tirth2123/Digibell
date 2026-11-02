import '../../../../api_models/api_response.dart';
import '../model/modify_notification_model.dart';

abstract class ModifyNotificationRepository {
  Future<ApiResponse<ModifyNotificationModel>> get();
}
