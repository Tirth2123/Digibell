import '../../../api_models/api_response.dart';
import '../model/register_model.dart';

abstract class RegisterRepository {
  Future<ApiResponse<RegisterModel>> register(dynamic data);
}