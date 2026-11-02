import '../../../../api_models/api_error.dart';
import '../model/subscription_details_model.dart';

class SubscriptionDetailsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final SubscriptionDetailsModel? subscriptionDetailsModel;

  SubscriptionDetailsState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.subscriptionDetailsModel});
}
