

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';

import '../../../../../utils/logger.dart';
import '../../../model/login_model.dart';
import '../../../repository/login/login_repository.dart';


part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _repository = GetIt.I<LoginRepository>();
  LoginBloc() : super(LoginState()) {
    on<PerformLoginEvent>(_perform);
  }
  void _perform(PerformLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginState(isLoading: true, isFailed: false));

    final response = await _repository.login(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(LoginState(
          isCompleted: true, isLoading: false, loginModel: response.data));
    } else {
      emit(LoginState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
