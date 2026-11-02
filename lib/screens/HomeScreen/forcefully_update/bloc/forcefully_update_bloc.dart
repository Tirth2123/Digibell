import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/forcefully_update_repository.dart';
import 'forcefully_update_event.dart';
import 'forcefully_update_state.dart';

class ForcefullyUpdateBloc extends Bloc<ForcefullyUpdateEvent, ForcefullyUpdateState> {
  final _repository = GetIt.I<ForcefullyUpdateRepository>();
  ForcefullyUpdateBloc() : super(ForcefullyUpdateState()) {
    on<PerformForcefullyUpdateEvent>(_perform);
  }

  void _perform(PerformForcefullyUpdateEvent event, Emitter<ForcefullyUpdateState> emit) async {
    emit(ForcefullyUpdateState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(ForcefullyUpdateState(isCompleted: true, isLoading: false, forcefullyUpdateModel: response.data));
    } else {
      emit(ForcefullyUpdateState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
