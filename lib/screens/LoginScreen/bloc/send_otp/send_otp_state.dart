part of 'send_otp_bloc.dart';

@immutable
class SendOtpState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final bool otpSent;
  final bool verified;
  final String? message;
  final SendOtp? model;

  const SendOtpState({
    this.otpSent = false,
    this.isLoading = false,
    this.verified = false,
    this.error,
    this.errorMsg,
    this.message,
    this.isCompleted = false,
    this.isFailed = false,
    this.model,
  });
}
