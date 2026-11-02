import '../../../../api_models/api_response.dart';
import '../../model/guest_user_model.dart';

abstract class GuestUserRepository {
  Future<ApiResponse<GuestUserModel>> guestUser();
}
