part of 'user_details_bloc.dart';



class UserDetailsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UserDetailsModel? userDetailsModel;

  UserDetailsState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.userDetailsModel});
}
