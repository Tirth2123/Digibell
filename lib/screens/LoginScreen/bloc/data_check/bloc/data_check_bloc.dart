import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../../utils/logger.dart';
import '../../../model/data_checks_model.dart';
import '../../../repository/data_check/data_check_repository.dart';


part 'data_check_event.dart';
part 'data_check_state.dart';

class DataCheckBloc extends Bloc<DataCheckEvent, DataCheckState> {
  final _loginRepository = GetIt.I<DataCheckRepository>();
  DataCheckBloc() : super(DataCheckState()) {
    on<PerformDataCheckEvent>(_perform);
  }
  void _perform(PerformDataCheckEvent event, Emitter<DataCheckState> emit) async {
    emit(DataCheckState(isLoading: true));
    final response = await _loginRepository.checkPhone(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(DataCheckState(isCompleted: true,
          // from: event.from,
          isLoading: false, model: response.data));
    } else {
      emit(DataCheckState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
