part of 'update_profile_bloc.dart';



class UpdateProfileState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UpdateProfileModel? updateProfileModel;

  UpdateProfileState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.updateProfileModel});
}
