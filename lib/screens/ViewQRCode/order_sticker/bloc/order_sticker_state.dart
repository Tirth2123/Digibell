import '../../../../api_models/api_error.dart';
import '../model/order_sticker_model.dart';

class OrderStickerState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final OrderStickerModel? orderStickerModel;

  OrderStickerState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.orderStickerModel});
}
