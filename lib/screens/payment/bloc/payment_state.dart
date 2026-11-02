import '../../../../api_models/api_error.dart';
import '../model/payment_model.dart';

class PaymentState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final PaymentModel? paymentModel;

  PaymentState({this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.paymentModel});
}
