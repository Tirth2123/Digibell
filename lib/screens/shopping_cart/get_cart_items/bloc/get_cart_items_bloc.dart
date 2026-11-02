import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_cart_items_repository.dart';
import 'get_cart_items_event.dart';
import 'get_cart_items_state.dart';

class GetCartItemsBloc extends Bloc<GetCartItemsEvent, GetCartItemsState> {
  final _repository = GetIt.I<GetCartItemsRepository>();
  GetCartItemsBloc() : super(GetCartItemsState()) {
    on<PerformGetCartItemsEvent>(_perform);
  }

  void _perform(PerformGetCartItemsEvent event, Emitter<GetCartItemsState> emit) async {
    emit(GetCartItemsState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetCartItemsState(isCompleted: true, isLoading: false, getCartItemsModel: response.data));
    } else {
      emit(GetCartItemsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
