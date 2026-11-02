import '../../../../api_models/api_response.dart';
import '../model/order_sticker_model.dart';

abstract class OrderStickerRepository {
  Future<ApiResponse<OrderStickerModel>> OrderSticker(dynamic data);
}
