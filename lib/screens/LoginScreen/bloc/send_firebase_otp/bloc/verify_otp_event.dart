part of 'verify_otp_bloc.dart';

abstract class VerifyOtpEvent {
  const VerifyOtpEvent();
}

class PerformVerifyOtpEvent extends VerifyOtpEvent {
  final dynamic verificationId;
  final dynamic otp;

  PerformVerifyOtpEvent({required this.verificationId, required this.otp});
}
