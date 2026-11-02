import '../../../../api_models/api_error.dart';
import '../../model/guest_user_model.dart';

class GuestUserState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GuestUserModel? guestUserModel;

  GuestUserState({this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.guestUserModel});
}
