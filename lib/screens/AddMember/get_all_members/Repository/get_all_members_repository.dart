import '../../../../api_models/api_response.dart';
import '../model/get_all_members_model.dart';

abstract class GetAllMembersRepository {
  Future<ApiResponse<GetAllMembersModel>> get();
}
