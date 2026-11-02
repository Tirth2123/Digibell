part of 'send_otp_bloc.dart';

@immutable
abstract class SendOtpEvent {
  const SendOtpEvent();
}

class PerformSendOtpEvent extends SendOtpEvent {
  final dynamic data;

  PerformSendOtpEvent({
    required this.data,
  });
}
