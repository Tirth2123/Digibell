
import '../../../../api_models/api_response.dart';
import '../model/purchse_order_model.dart';

abstract class PurchseOrderRepository {
  Future<ApiResponse<PurchseOrderModel>> purchseOrder(dynamic data);
}
