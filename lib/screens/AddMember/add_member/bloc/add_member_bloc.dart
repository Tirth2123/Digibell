import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/add_member_repository.dart';
import 'add_member_event.dart';
import 'add_member_state.dart';

class AddMemberBloc extends Bloc<AddMemberEvent, AddMemberState> {
  final _repository = GetIt.I<AddMemberRepository>();
  AddMemberBloc() : super(AddMemberState()) {
    on<PerformAddMemberEvent>(_perform);
  }
  void _perform(PerformAddMemberEvent event, Emitter<AddMemberState> emit) async {
    emit(AddMemberState(isLoading: true, isFailed: false));

    final response = await _repository.AddMember(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(AddMemberState(isCompleted: true, isLoading: false, addMemberModel: response.data));
    } else {
      emit(AddMemberState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
