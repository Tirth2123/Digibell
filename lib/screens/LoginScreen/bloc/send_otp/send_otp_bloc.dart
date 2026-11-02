import 'package:Digibells/api_models/api_error.dart';
import 'package:Digibells/api_models/api_status.dart';
import 'package:Digibells/screens/LoginScreen/model/send_otp.dart';
import 'package:Digibells/screens/LoginScreen/repository/send_otp/send_otp_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../utils/logger.dart';

part 'send_otp_event.dart';
part 'send_otp_state.dart';

class SendOtpBloc extends Bloc<SendOtpEvent, SendOtpState> {
  final _loginRepository = GetIt.I<SendOtpRepository>();
  SendOtpBloc() : super(SendOtpState()) {
    on<PerformSendOtpEvent>(_perform);
  }
  void _perform(PerformSendOtpEvent event, Emitter<SendOtpState> emit) async {
    emit(SendOtpState(isLoading: true));
    final response = await _loginRepository.sendOtp(event.data);
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(SendOtpState(
        isCompleted: true,
        isLoading: false,
        model: response.data,
      ));
    } else {
      emit(SendOtpState(
          error: response.error,
          errorMsg: response.errorMsg,
          isFailed: true,
          isLoading: false,
          isCompleted: false,
      ));
    }
  }
}
