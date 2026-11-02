import '../../../../api_models/api_error.dart';
import '../model/remove_member_model.dart';

class RemoveMemberState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final RemoveMemberModel? removeMemberModel;

  RemoveMemberState(
      {this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.removeMemberModel});
}
