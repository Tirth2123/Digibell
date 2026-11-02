import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/modify_notification_repository.dart';
import 'modify_notification_event.dart';
import 'modify_notification_state.dart';

class ModifyNotificationBloc extends Bloc<ModifyNotificationEvent, ModifyNotificationState> {
  final _repository = GetIt.I<ModifyNotificationRepository>();
  ModifyNotificationBloc() : super(ModifyNotificationState()) {
    on<PerformModifyNotificationEvent>(_perform);
  }

  void _perform(PerformModifyNotificationEvent event, Emitter<ModifyNotificationState> emit) async {
    emit(ModifyNotificationState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(ModifyNotificationState(isCompleted: true, isLoading: false, modifyNotificationModel: response.data));
    } else {
      emit(ModifyNotificationState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
