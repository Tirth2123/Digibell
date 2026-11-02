import '../../../../api_models/api_error.dart';
import '../model/upgrade_plan_model.dart';

class UpgradePlanState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UpgradePlanModel? upgradePlanModel;

  UpgradePlanState({this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.upgradePlanModel});
}
