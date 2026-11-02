import '../../../../api_models/api_error.dart';
import '../model/add_member_model.dart';

class AddMemberState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final AddMemberModel? addMemberModel;

  AddMemberState({this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.addMemberModel});
}
