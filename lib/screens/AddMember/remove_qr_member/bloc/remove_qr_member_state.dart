
import '../../../../api_models/api_error.dart';
import '../model/remove_qr_member_model.dart';

class RemoveQRMemberState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final RemoveQRMemberModel? removeQRMemberModel;

  RemoveQRMemberState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.removeQRMemberModel});
}
