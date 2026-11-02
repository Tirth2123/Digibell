import '../../../../../api_models/api_response.dart';
import '../model/add_qr_member_model.dart';

abstract class AddQRMemberRepository {
  Future<ApiResponse<AddQRMemberModel>> AddQRMember(dynamic data, dynamic id);
}
