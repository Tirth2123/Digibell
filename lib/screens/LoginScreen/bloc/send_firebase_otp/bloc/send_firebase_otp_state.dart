part of 'send_firebase_otp_bloc.dart';

@immutable
class SendFirebaseOtpState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final bool otpSent;
  final bool verified;
  final String? message;

  const SendFirebaseOtpState({
    this.otpSent = false,
    this.isLoading = false,
    this.verified = false,
    this.error,
    this.errorMsg,
    this.message,
    this.isCompleted = false,
    this.isFailed = false,
  });

  SendFirebaseOtpState copyWith({
    bool? isLoading,
    ApiError? error,
    String? errorMsg,
    String? message,
    bool? isCompleted,
    bool? isFailed,
    bool? otpSent,
    bool? verified,
  }) {
    return SendFirebaseOtpState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      errorMsg: errorMsg ?? this.errorMsg,
      message: message ?? this.message,
      isCompleted: isCompleted ?? this.isCompleted,
      isFailed: isFailed ?? this.isFailed,
      otpSent: otpSent ?? this.otpSent,
      verified: verified ?? this.verified,
    );
  }
}
