import '../../../../api_models/api_response.dart';
import '../model/remove_member_model.dart';

abstract class RemoveMemberRepository {
  Future<ApiResponse<RemoveMemberModel>> RemoveMember(dynamic id);
}
