import '../../../api_models/api_response.dart';

import '../model/user_details_model.dart';

abstract class UserDetailsRepository {
  Future<ApiResponse<UserDetailsModel>> userDetails(dynamic data);
}