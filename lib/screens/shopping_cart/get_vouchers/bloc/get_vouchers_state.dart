import '../../../../api_models/api_error.dart';
import '../model/get_vouchers_model.dart';

class GetVouchersState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetVouchersModel? getVouchersModel;

  GetVouchersState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.getVouchersModel,
  });
}
