import '../../../../api_models/api_response.dart';
import '../model/product_details_model.dart';


abstract class ProductDetailsRepository {

  Future<ApiResponse<ProductDetailsModel>> productDetails(dynamic id);
}



