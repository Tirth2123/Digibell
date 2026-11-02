import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/order_sticker_repository.dart';
import 'order_sticker_event.dart';
import 'order_sticker_state.dart';

class OrderStickerBloc extends Bloc<OrderStickerEvent, OrderStickerState> {
  final _repository = GetIt.I<OrderStickerRepository>();
  OrderStickerBloc() : super(OrderStickerState()) {
    on<PerformOrderStickerEvent>(_perform);
  }
  void _perform(PerformOrderStickerEvent event, Emitter<OrderStickerState> emit) async {
    emit(OrderStickerState(isLoading: true, isFailed: false));

    final response = await _repository.OrderSticker(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(OrderStickerState(isCompleted: true, isLoading: false, orderStickerModel: response.data));
    } else {
      emit(OrderStickerState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
