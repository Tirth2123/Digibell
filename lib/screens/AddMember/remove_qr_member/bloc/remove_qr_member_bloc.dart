import 'package:Digibells/screens/AddMember/remove_qr_member/bloc/remove_qr_member_event.dart';
import 'package:Digibells/screens/AddMember/remove_qr_member/bloc/remove_qr_member_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/remove_qr_member_repository.dart';

class RemoveQRMemberBloc extends Bloc<RemoveQRMemberEvent, RemoveQRMemberState> {
  final _repository = GetIt.I<RemoveQRMemberRepository>();
  RemoveQRMemberBloc() : super(RemoveQRMemberState()) {
    on<PerformRemoveQRMemberEvent>(_perform);
  }
  void _perform(PerformRemoveQRMemberEvent event, Emitter<RemoveQRMemberState> emit) async {
    emit(RemoveQRMemberState(isLoading: true, isFailed: false));

    final response = await _repository.RemoveQRMember(event.data, event.id);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(RemoveQRMemberState(isCompleted: true, isLoading: false, removeQRMemberModel: response.data));
    } else {
      emit(RemoveQRMemberState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
