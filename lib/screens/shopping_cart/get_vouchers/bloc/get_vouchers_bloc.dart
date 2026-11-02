import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_vouchers_repository.dart';
import 'get_vouchers_event.dart';
import 'get_vouchers_state.dart';

class GetVouchersBloc extends Bloc<GetVouchersEvent, GetVouchersState> {
  final _repository = GetIt.I<GetVouchersRepository>();
  GetVouchersBloc() : super(GetVouchersState()) {
    on<PerformGetVouchersEvent>(_perform);
  }

  void _perform(PerformGetVouchersEvent event, Emitter<GetVouchersState> emit) async {
    emit(GetVouchersState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetVouchersState(isCompleted: true, isLoading: false, getVouchersModel: response.data));
    } else {
      emit(GetVouchersState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
