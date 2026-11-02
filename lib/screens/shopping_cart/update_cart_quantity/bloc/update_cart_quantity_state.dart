import '../../../../api_models/api_error.dart';
import '../model/update_cart_quantity_model.dart';

class UpdateCartQuantityState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UpdateCartQuantityModel? updateCartQuantityModel;

  UpdateCartQuantityState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.updateCartQuantityModel});
}
