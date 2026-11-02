import 'package:Digibells/screens/shopping_cart/remove_cart_item/bloc/remove_cart_item_event.dart';
import 'package:Digibells/screens/shopping_cart/remove_cart_item/bloc/remove_cart_item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/remove_cart_item_repository.dart';

class RemoveCartItemBloc extends Bloc<RemoveCartItemEvent, RemoveCartItemState> {
  final _repository = GetIt.I<RemoveCartItemRepository>();
  RemoveCartItemBloc() : super(RemoveCartItemState()) {
    on<PerformRemoveCartItemEvent>(_perform);
  }
  void _perform(PerformRemoveCartItemEvent event, Emitter<RemoveCartItemState> emit) async {
    emit(RemoveCartItemState(isLoading: true, isFailed: false));

    final response = await _repository.RemoveCartItem(event.id);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(RemoveCartItemState(isCompleted: true, isLoading: false, removeCartItemModel: response.data));
    } else {
      emit(RemoveCartItemState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
