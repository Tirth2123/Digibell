import '../../../../api_models/api_response.dart';
import '../model/decline_invite_model.dart';

abstract class DeclineInviteRepository {
  Future<ApiResponse<DeclineInviteModel>> DeclineInvite(dynamic id);
}
