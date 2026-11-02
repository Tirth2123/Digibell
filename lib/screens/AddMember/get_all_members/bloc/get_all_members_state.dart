import '../../../../api_models/api_error.dart';
import '../model/get_all_members_model.dart';

class GetAllMembersState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetAllMembersModel? getAllMembersModel;

  GetAllMembersState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.getAllMembersModel,
  });
}
