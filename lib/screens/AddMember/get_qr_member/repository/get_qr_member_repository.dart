import '../../../../../api_models/api_response.dart';
import '../model/get_qr_member_model.dart';

abstract class GetQRMemberRepository {
  Future<ApiResponse<GetQRMemberModel>> GetQRMember(  dynamic id);
}
