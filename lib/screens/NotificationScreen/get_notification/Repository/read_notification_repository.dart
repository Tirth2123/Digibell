
import 'package:Digibells/api_models/api_response.dart';

abstract class ReadNotificationsRepository {
  Future<ApiResponse<Map>> readNotification();
}
