import '../../../../api_models/api_response.dart';
import '../../model/login_model.dart';



abstract class SocialLoginRepository {
  Future<ApiResponse<LoginModel>> socialLogin(dynamic data);
}
