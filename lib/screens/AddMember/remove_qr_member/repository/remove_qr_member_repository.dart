import '../../../../../api_models/api_response.dart';
import '../model/remove_qr_member_model.dart';

abstract class RemoveQRMemberRepository {
  Future<ApiResponse<RemoveQRMemberModel>> RemoveQRMember(dynamic data, dynamic id);
}
