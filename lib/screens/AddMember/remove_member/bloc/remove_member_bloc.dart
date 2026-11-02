import 'package:Digibells/screens/AddMember/remove_member/bloc/remove_member_event.dart';
import 'package:Digibells/screens/AddMember/remove_member/bloc/remove_member_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/remove_member_repository.dart';

class RemoveMemberBloc extends Bloc<RemoveMemberEvent, RemoveMemberState> {
  final _repository = GetIt.I<RemoveMemberRepository>();
  RemoveMemberBloc() : super(RemoveMemberState()) {
    on<PerformRemoveMemberEvent>(_perform);
  }
  void _perform(PerformRemoveMemberEvent event, Emitter<RemoveMemberState> emit) async {
    emit(RemoveMemberState(isLoading: true, isFailed: false));

    final response = await _repository.RemoveMember(event.id);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(RemoveMemberState(isCompleted: true, isLoading: false, removeMemberModel: response.data));
    } else {
      emit(RemoveMemberState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
