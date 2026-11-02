import '../../../../api_models/api_response.dart';
import '../model/product_list_model.dart';


abstract class ProductListRepository {
  Future<ApiResponse<ProductListModel>> productList(dynamic page, dynamic searchQuery);
}
