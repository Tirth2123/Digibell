part of 'send_firebase_otp_bloc.dart';

@immutable
abstract class SendFirebaseOtpEvent {
  const SendFirebaseOtpEvent();
}

class PerformSendFirebaseOtpEvent extends SendFirebaseOtpEvent {
  final dynamic phoneNumber;

  PerformSendFirebaseOtpEvent({
    required this.phoneNumber,
  });
}

// class PerformVerifyOtpEvent extends SendFirebaseOtpEvent {
//   final dynamic verificationId;
//   final dynamic otp;
//
//   PerformVerifyOtpEvent({required this.verificationId, required this.otp});
// }
