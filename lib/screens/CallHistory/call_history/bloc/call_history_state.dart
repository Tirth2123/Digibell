import '../../../../api_models/api_error.dart';
import '../model/call_history_model.dart';

class CallHistoryState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final CallHistoryModel? callHistoryModel;

  CallHistoryState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.callHistoryModel,
  });
}
