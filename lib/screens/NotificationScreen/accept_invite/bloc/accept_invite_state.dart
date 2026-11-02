import '../../../../api_models/api_error.dart';
import '../model/accept_invite_model.dart';

class AcceptInviteState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final AcceptInviteModel? acceptInviteModel;

  AcceptInviteState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.acceptInviteModel});
}
