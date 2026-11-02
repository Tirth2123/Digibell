import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../../utils/logger.dart';
import '../../repository/guest_user/guest_user_repository.dart';
import 'guest_user_event.dart';
import 'guest_user_state.dart';

class GuestUserBloc extends Bloc<GuestUserEvent, GuestUserState> {
  final _repository = GetIt.I<GuestUserRepository>();
  GuestUserBloc() : super(GuestUserState()) {
    on<PerformGuestUserEvent>(_perform);
  }
  void _perform(PerformGuestUserEvent event, Emitter<GuestUserState> emit) async {
    emit(GuestUserState(isLoading: true, isFailed: false));

    final response = await _repository.guestUser();
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(GuestUserState(isCompleted: true, isLoading: false, guestUserModel: response.data));
    } else {
      emit(GuestUserState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
