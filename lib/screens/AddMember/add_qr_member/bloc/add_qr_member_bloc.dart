import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/add_qr_member_repository.dart';
import 'add_qr_member_event.dart';
import 'add_qr_member_state.dart';


class AddQRMemberBloc extends Bloc<AddQRMemberEvent, AddQRMemberState> {
  final _repository = GetIt.I<AddQRMemberRepository>();
  AddQRMemberBloc() : super(AddQRMemberState()) {
    on<PerformAddQRMemberEvent>(_perform);
  }
  void _perform(PerformAddQRMemberEvent event, Emitter<AddQRMemberState> emit) async {
    emit(AddQRMemberState(isLoading: true, isFailed: false));

    final response = await _repository.AddQRMember(event.data, event.id);
    logger.w('REPONSE_STATUS ${response.status}');
     if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS 11${response.status}');
       emit(AddQRMemberState(isCompleted: true, isLoading: false, addQRMemberModel: response.data));
    } else {
      emit(AddQRMemberState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
