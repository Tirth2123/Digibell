import '../../../../../api_models/api_response.dart';
import '../model/update_cart_quantity_model.dart';

abstract class UpdateCartQuantityRepository {
  Future<ApiResponse<UpdateCartQuantityModel>> UpdateCartQuantity(dynamic data, dynamic id);
}
