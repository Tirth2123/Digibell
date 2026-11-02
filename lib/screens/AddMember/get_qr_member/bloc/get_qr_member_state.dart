import '../../../../api_models/api_error.dart';
import '../model/get_qr_member_model.dart';

class GetQRMemberState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetQRMemberModel? getQRMemberModel;

  GetQRMemberState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.getQRMemberModel});
}
