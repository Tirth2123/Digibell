import '../../../../api_models/api_error.dart';
import '../model/remove_cart_item_model.dart';

class RemoveCartItemState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final RemoveCartItemModel? removeCartItemModel;

  RemoveCartItemState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.removeCartItemModel});
}
