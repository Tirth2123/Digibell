import '../../../../api_models/api_response.dart';
import '../model/upgrade_plan_model.dart';

abstract class UpgradePlanRepository {
  Future<ApiResponse<UpgradePlanModel>> UpgradePlan(dynamic data);
}
