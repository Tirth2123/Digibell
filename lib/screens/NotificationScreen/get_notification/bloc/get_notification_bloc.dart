import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_notification_repository.dart';
import 'get_notification_event.dart';
import 'get_notification_state.dart';

class GetNotificationsBloc extends Bloc<GetNotificationsEvent, GetNotificationsState> {
  final _repository = GetIt.I<GetNotificationsRepository>();
  GetNotificationsBloc() : super(GetNotificationsState()) {
    on<PerformGetNotificationsEvent>(_perform);
  }

  void _perform(PerformGetNotificationsEvent event, Emitter<GetNotificationsState> emit) async {
    emit(GetNotificationsState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetNotificationsState(isCompleted: true, isLoading: false, getNotificationsModel: response.data));
    } else {
      emit(GetNotificationsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
