import '../../../../api_models/api_error.dart';
import '../model/update_qr_status_model.dart';

class UpdateQRStatusState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UpdateQRStatusModel? updateQRStatusModel;

  UpdateQRStatusState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.updateQRStatusModel});
}
