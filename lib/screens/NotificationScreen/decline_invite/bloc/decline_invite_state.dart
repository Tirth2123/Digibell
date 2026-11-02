import '../../../../api_models/api_error.dart';
import '../model/decline_invite_model.dart';

class DeclineInviteState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final DeclineInviteModel? declineInviteModel;

  DeclineInviteState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.declineInviteModel});
}
