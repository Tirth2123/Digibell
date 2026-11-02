part of 'register_bloc.dart';


class RegisterState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final RegisterModel? registerModel;

  RegisterState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.registerModel});
}
