import '../../../../api_models/api_error.dart';
import '../model/get_cart_items_model.dart';

class GetCartItemsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetCartItemsModel? getCartItemsModel;

  GetCartItemsState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.getCartItemsModel,
  });
}
