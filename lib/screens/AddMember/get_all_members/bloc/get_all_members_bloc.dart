import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_all_members_repository.dart';
import 'get_all_members_event.dart';
import 'get_all_members_state.dart';

class GetAllMembersBloc extends Bloc<GetAllMembersEvent, GetAllMembersState> {
  final _repository = GetIt.I<GetAllMembersRepository>();
  GetAllMembersBloc() : super(GetAllMembersState()) {
    on<PerformGetAllMembersEvent>(_perform);
  }

  void _perform(PerformGetAllMembersEvent event, Emitter<GetAllMembersState> emit) async {
    emit(GetAllMembersState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetAllMembersState(isCompleted: true, isLoading: false, getAllMembersModel: response.data));
    } else {
      emit(GetAllMembersState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
