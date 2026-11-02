import '../../../../api_models/api_response.dart';
import '../model/add_member_model.dart';

abstract class AddMemberRepository {
  Future<ApiResponse<AddMemberModel>> AddMember(dynamic data);
}
