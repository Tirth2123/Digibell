import '../../../../api_models/api_response.dart';
import '../model/get_cart_items_model.dart';

abstract class GetCartItemsRepository {
  Future<ApiResponse<GetCartItemsModel>> get();
}
