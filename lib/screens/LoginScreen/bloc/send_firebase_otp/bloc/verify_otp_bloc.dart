import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';
import '../../../repository/send_firebase_otp/verify_otp_repository.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final _repository = GetIt.I<VerifyMobileOTPRepository>();

  VerifyOtpBloc() : super(const VerifyOtpState()) {
    on<PerformVerifyOtpEvent>(_performVerifyOTP);
  }

  void _performVerifyOTP(
      PerformVerifyOtpEvent event, Emitter<VerifyOtpState> emit) async {
    emit(state.copyWith(isLoading: true, isFailed: false));
    final response =
        await _repository.verifyOTP(event.verificationId, event.otp);

    if (response.status == ApiStatus.success) {
      emit(state.copyWith(
          verified: true,
          isLoading: false,
          isCompleted: true,
          message: response.data));
    } else {
      emit(state.copyWith(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        verified: false,
      ));
    }
  }
}
