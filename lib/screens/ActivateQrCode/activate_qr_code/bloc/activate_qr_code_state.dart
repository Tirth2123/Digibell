import '../../../../api_models/api_error.dart';
import '../model/activate_qr_code_model.dart';

class ActivateQRCodeState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final ActivateQRCodeModel? activateQRCodeModel;

  ActivateQRCodeState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.activateQRCodeModel});
}
