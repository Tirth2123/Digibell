import '../../../../api_models/api_error.dart';
import '../model/add_qr_details_model.dart';

class AddQRDetailsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final AddQRDetailsModel? addQRDetailsModel;

  AddQRDetailsState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.addQRDetailsModel});
}
