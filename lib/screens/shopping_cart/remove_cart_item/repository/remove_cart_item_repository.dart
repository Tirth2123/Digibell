import '../../../../api_models/api_response.dart';
import '../model/remove_cart_item_model.dart';

abstract class RemoveCartItemRepository {
  Future<ApiResponse<RemoveCartItemModel>> RemoveCartItem(dynamic id);
}
