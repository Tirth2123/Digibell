import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/accept_invite_repository.dart';
import 'accept_invite_event.dart';
import 'accept_invite_state.dart';

class AcceptInviteBloc extends Bloc<AcceptInviteEvent, AcceptInviteState> {
  final _repository = GetIt.I<AcceptInviteRepository>();
  AcceptInviteBloc() : super(AcceptInviteState()) {
    on<PerformAcceptInviteEvent>(_perform);
  }
  void _perform(PerformAcceptInviteEvent event, Emitter<AcceptInviteState> emit) async {
    emit(AcceptInviteState(isLoading: true, isFailed: false));

    final response = await _repository.AcceptInvite(event.id);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(AcceptInviteState(isCompleted: true, isLoading: false, acceptInviteModel: response.data));
    } else {
      emit(AcceptInviteState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
