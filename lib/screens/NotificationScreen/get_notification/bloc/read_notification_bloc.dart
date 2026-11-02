import 'package:Digibells/api_models/api_status.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/Repository/read_notification_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'read_notification_event.dart';

part 'read_notification_state.dart';

class ReadNotificationBloc
    extends Bloc<ReadNotificationEvent, ReadNotificationState> {
  final _repository = GetIt.I<ReadNotificationsRepository>();

  ReadNotificationBloc() : super(ReadNotificationState()) {
    on<PerformReadNotificationEvent>(_perform);
  }

  void _perform(PerformReadNotificationEvent event,
      Emitter<ReadNotificationState> emit) async {
    emit(ReadNotificationState(isLoading: true, isFailed: false));
    final response = await _repository.readNotification();
    if (response.status == ApiStatus.success) {
      emit(ReadNotificationState(
        isCompleted: true,
        isLoading: false,
      ));
    } else {
      emit(ReadNotificationState(
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
