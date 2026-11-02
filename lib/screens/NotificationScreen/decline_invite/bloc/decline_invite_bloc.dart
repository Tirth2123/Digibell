import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/decline_invite_repository.dart';
import 'decline_invite_event.dart';
import 'decline_invite_state.dart';

class DeclineInviteBloc extends Bloc<DeclineInviteEvent, DeclineInviteState> {
  final _repository = GetIt.I<DeclineInviteRepository>();
  DeclineInviteBloc() : super(DeclineInviteState()) {
    on<PerformDeclineInviteEvent>(_perform);
  }
  void _perform(PerformDeclineInviteEvent event, Emitter<DeclineInviteState> emit) async {
    emit(DeclineInviteState(isLoading: true, isFailed: false));

    final response = await _repository.DeclineInvite(event.id);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(DeclineInviteState(isCompleted: true, isLoading: false, declineInviteModel: response.data));
    } else {
      emit(DeclineInviteState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
