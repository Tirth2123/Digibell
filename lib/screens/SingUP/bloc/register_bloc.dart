import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../api_models/api_error.dart';
import '../../../api_models/api_status.dart';
import '../../../utils/logger.dart';
import '../model/register_model.dart';
import '../repository/register_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final _repository = GetIt.I<RegisterRepository>();
  RegisterBloc() : super(RegisterState()) {
    on<PerformRegisterEvent>(_perform);
  }
  void _perform(PerformRegisterEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterState(isLoading: true, isFailed: false));

    final response = await _repository.register(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(RegisterState(
          isCompleted: true, isLoading: false, registerModel: response.data));
    } else {
      emit(RegisterState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
