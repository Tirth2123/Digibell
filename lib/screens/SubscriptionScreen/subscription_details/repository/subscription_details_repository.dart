import '../../../../api_models/api_response.dart';
import '../model/subscription_details_model.dart';

abstract class SubscriptionDetailsRepository {
  Future<ApiResponse<SubscriptionDetailsModel>> SubscriptionDetails(dynamic type, dynamic search);
}
