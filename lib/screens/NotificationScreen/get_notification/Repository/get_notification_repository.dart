import '../../../../api_models/api_response.dart';
import '../model/get_notification_model.dart';

abstract class GetNotificationsRepository {
  Future<ApiResponse<GetNotificationsModel>> get();
}
