import '../../../../api_models/api_response.dart';
import '../model/payment_model.dart';

abstract class PaymentRepository {
  Future<ApiResponse<PaymentModel>> Payment(dynamic data);
}
