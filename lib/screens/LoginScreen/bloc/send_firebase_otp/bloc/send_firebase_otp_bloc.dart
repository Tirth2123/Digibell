import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../../utils/logger.dart';
import '../../../repository/send_firebase_otp/send_firebase_otp_repository.dart';

part 'send_firebase_otp_event.dart';

part 'send_firebase_otp_state.dart';

class SendFirebaseOtpBloc
    extends Bloc<SendFirebaseOtpEvent, SendFirebaseOtpState> {
  final _repository = GetIt.I<SendMobileOTPRepository>();

  String verificationId = '';

  SendFirebaseOtpBloc() : super(SendFirebaseOtpState()) {
    on<PerformSendFirebaseOtpEvent>(_perform);
    // on<PerformVerifyOtpEvent>(_performVerifyOTP);
  }

  void _perform(PerformSendFirebaseOtpEvent event,
      Emitter<SendFirebaseOtpState> emit) async {
    emit(state.copyWith(isLoading: true, isFailed: false));
    final response = await _repository.sendOTP(event.phoneNumber);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('Bloc Success - ${response.data}');
      verificationId = response.data;
      return emit(state.copyWith(
          otpSent: true,
          verified: false,
          isLoading: false,
          isCompleted: true,
          message: response.data));
    } else {
      return emit(state.copyWith(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        verified: false,
        otpSent: false,
      ));
    }
  }

  // void _performVerifyOTP(
  //     PerformVerifyOtpEvent event, Emitter<SendFirebaseOtpState> emit) async {
  //   emit(state.copyWith(isLoading: true, isFailed: false));
  //   final response =
  //       await _repository.verifyOTP(event.verificationId, event.otp);
  //
  //   if (response.status == ApiStatus.success) {
  //     emit(state.copyWith(
  //         otpSent: false,
  //         verified: true,
  //         isLoading: false,
  //         isCompleted: true,
  //         message: response.data));
  //   } else {
  //     emit(state.copyWith(
  //       error: response.error,
  //       errorMsg: response.errorMsg,
  //       isFailed: true,
  //       isLoading: false,
  //       otpSent: false,
  //       verified: false,
  //     ));
  //   }
  // }
}
