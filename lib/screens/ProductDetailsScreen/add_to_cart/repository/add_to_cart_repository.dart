import '../../../../api_models/api_response.dart';
import '../model/add_to_cart_model.dart';

abstract class AddToCartRepository {
  Future<ApiResponse<AddToCartModel>> AddToCart(dynamic data);
}
