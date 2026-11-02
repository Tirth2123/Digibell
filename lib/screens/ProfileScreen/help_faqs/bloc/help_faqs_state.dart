import '../../../../api_models/api_error.dart';
import '../model/help_faqs_model.dart';

class HelpFaqsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final HelpFaqsModel? helpFaqsModel;

  HelpFaqsState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.helpFaqsModel,
  });
}
