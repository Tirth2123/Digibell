part of 'social_login_bloc.dart';

class SocialLoginState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final String? email;
  final bool isCompleted;
  final bool isEmailVerified;
  final bool isFailed;
  final LoginModel? model;
  final int? statusCode;

  SocialLoginState({
    this.isLoading = false,
    this.error,
    this.email,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.isEmailVerified = false,
    this.model,
    this.statusCode,
  });
}
