import '../../../../api_models/api_error.dart';
import '../model/in_app_purchase_model.dart';

class InAppPurchaseState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final InAppPurchaseModel? inAppPurchaseModel;

  InAppPurchaseState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.inAppPurchaseModel});
}
