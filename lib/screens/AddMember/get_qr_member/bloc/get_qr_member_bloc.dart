import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/get_qr_member_repository.dart';
import 'get_qr_member_event.dart';
import 'get_qr_member_state.dart';

class GetQRMemberBloc extends Bloc<GetQRMemberEvent, GetQRMemberState> {
  final _repository = GetIt.I<GetQRMemberRepository>();
  GetQRMemberBloc() : super(GetQRMemberState()) {
    on<PerformGetQRMemberEvent>(_perform);
  }
  void _perform(PerformGetQRMemberEvent event, Emitter<GetQRMemberState> emit) async {
    emit(GetQRMemberState(isLoading: true, isFailed: false));

    final response = await _repository.GetQRMember(event.id);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(GetQRMemberState(isCompleted: true, isLoading: false, getQRMemberModel: response.data));
    } else {
      emit(GetQRMemberState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
