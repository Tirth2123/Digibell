import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/model/update_qr_details_model.dart';

import '../../../../api_models/api_error.dart';

class UpdateQRDetailsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UpdateQRDetailsModel? updateQRDetailsModel;

  UpdateQRDetailsState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.updateQRDetailsModel});
}
