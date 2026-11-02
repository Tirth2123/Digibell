import '../../../../api_models/api_error.dart';
import '../model/forcefully_update_model.dart';

class ForcefullyUpdateState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final ForcefullyUpdateModel? forcefullyUpdateModel;

  ForcefullyUpdateState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.forcefullyUpdateModel,
  });
}
