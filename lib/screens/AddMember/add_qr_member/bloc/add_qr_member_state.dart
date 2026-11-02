 


import '../../../../api_models/api_error.dart';
import '../model/add_qr_member_model.dart';

class AddQRMemberState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final AddQRMemberModel? addQRMemberModel;

  AddQRMemberState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.addQRMemberModel});
}
