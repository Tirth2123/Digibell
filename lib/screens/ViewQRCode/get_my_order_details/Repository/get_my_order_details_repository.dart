import '../../../../api_models/api_response.dart';
import '../model/get_my_order_details_model.dart';

abstract class GetMyOrderRepository {
  Future<ApiResponse<GetMyOrderModel>> get();
}
