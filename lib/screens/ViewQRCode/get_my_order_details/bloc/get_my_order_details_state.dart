import '../../../../api_models/api_error.dart';
import '../model/get_my_order_details_model.dart';

class GetMyOrderState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetMyOrderModel? getMyOrderModel;

  GetMyOrderState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.getMyOrderModel,
  });
}
