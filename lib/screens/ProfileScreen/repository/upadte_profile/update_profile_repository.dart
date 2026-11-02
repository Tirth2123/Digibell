
import '../../../../api_models/api_response.dart';
import '../../model/update_profile_model.dart';

abstract class UpdateProfileRepository {
  Future<ApiResponse<UpdateProfileModel>> updateProfile(dynamic data);
}
