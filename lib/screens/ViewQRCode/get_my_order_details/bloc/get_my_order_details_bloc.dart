import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_my_order_details_repository.dart';
import 'get_my_order_details_event.dart';
import 'get_my_order_details_state.dart';

class GetMyOrderBloc extends Bloc<GetMyOrderEvent, GetMyOrderState> {
  final _repository = GetIt.I<GetMyOrderRepository>();
  GetMyOrderBloc() : super(GetMyOrderState()) {
    on<PerformGetMyOrderEvent>(_perform);
  }

  void _perform(PerformGetMyOrderEvent event, Emitter<GetMyOrderState> emit) async {
    emit(GetMyOrderState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetMyOrderState(isCompleted: true, isLoading: false, getMyOrderModel: response.data));
    } else {
      emit(GetMyOrderState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
