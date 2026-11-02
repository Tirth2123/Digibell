import '../../../../api_models/api_response.dart';
import '../model/logout_model.dart';

abstract class LogoutRepository {
  Future<ApiResponse<LogoutModel>> add(dynamic data);
}
