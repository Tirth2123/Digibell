import '../../../../api_models/api_error.dart';
import '../model/purchse_order_model.dart';

class PurchseOrderState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final PurchseOrderModel? purchseOrderModel;

  PurchseOrderState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.purchseOrderModel});
}
