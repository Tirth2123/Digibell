import 'package:Digibells/screens/ProfileScreen/logout/Repository/logout_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/alert_utils.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final _repository = GetIt.I<LogoutRepository>();
  LogoutBloc() : super(LogoutState()) {
    on<PerformLogoutEvent>(_perform);
  }

  void _perform(PerformLogoutEvent event, Emitter<LogoutState> emit) async {
    emit(LogoutState(isLoading: true, isFailed: false));
    final response = await _repository.add(event.data);
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(LogoutState(isCompleted: true, isLoading: false, logoutModel: response.data));
    } else {
      emit(LogoutState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
