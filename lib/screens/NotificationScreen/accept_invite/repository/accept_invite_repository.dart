import '../../../../api_models/api_response.dart';
import '../model/accept_invite_model.dart';

abstract class AcceptInviteRepository {
  Future<ApiResponse<AcceptInviteModel>> AcceptInvite(dynamic id);
}
