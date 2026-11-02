import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/call_history_repository.dart';
import 'call_history_event.dart';
import 'call_history_state.dart';

class CallHistoryBloc extends Bloc<CallHistoryEvent, CallHistoryState> {
  final _repository = GetIt.I<CallHistoryRepository>();
  CallHistoryBloc() : super(CallHistoryState()) {
    on<PerformCallHistoryEvent>(_perform);
  }

  void _perform(PerformCallHistoryEvent event, Emitter<CallHistoryState> emit) async {
    emit(CallHistoryState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(CallHistoryState(isCompleted: true, isLoading: false, callHistoryModel: response.data));
    } else {
      emit(CallHistoryState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
