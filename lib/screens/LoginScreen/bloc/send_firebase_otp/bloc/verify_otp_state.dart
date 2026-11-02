part of 'verify_otp_bloc.dart';

@immutable
class VerifyOtpState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final bool verified;
  final String? message;

  const VerifyOtpState({
    this.isLoading = false,
    this.verified = false,
    this.error,
    this.errorMsg,
    this.message,
    this.isCompleted = false,
    this.isFailed = false,
  });

  VerifyOtpState copyWith({
    bool? isLoading,
    ApiError? error,
    String? errorMsg,
    String? message,
    bool? isCompleted,
    bool? isFailed,
    bool? verified,
  }) {
    return VerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      errorMsg: errorMsg ?? this.errorMsg,
      message: message ?? this.message,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
      verified: verified ?? this.verified,
    );
  }
}
