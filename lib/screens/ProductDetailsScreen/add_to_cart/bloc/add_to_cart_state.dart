import '../../../../api_models/api_error.dart';
import '../model/add_to_cart_model.dart';

class AddToCartState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final AddToCartModel? addToCartModel;

  AddToCartState({this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.addToCartModel});
}
