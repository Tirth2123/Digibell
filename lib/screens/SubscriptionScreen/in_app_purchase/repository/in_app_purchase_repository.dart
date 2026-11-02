import '../../../../api_models/api_response.dart';
import '../model/in_app_purchase_model.dart';

abstract class InAppPurchaseRepository {
  Future<ApiResponse<InAppPurchaseModel>> InAppPurchase(dynamic data);
}
