import '../../../../api_models/api_error.dart';
import '../model/reactivate_account_model.dart';

class ReactivateAccountState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final ReactivateAccountModel? reactivateAccountModel;

  ReactivateAccountState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.reactivateAccountModel});
}
