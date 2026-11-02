import 'package:Digibells/screens/shopping_cart/update_cart_quantity/bloc/update_cart_quantity_event.dart';
import 'package:Digibells/screens/shopping_cart/update_cart_quantity/bloc/update_cart_quantity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../api_models/api_status.dart';
import '../repository/update_cart_quantity_repository.dart';

class UpdateCartQuantityBloc extends Bloc<UpdateCartQuantityEvent, UpdateCartQuantityState> {
  final _repository = GetIt.I<UpdateCartQuantityRepository>();
  UpdateCartQuantityBloc() : super(UpdateCartQuantityState()) {
    on<PerformUpdateCartQuantityEvent>(_perform);
  }
  void _perform(PerformUpdateCartQuantityEvent event, Emitter<UpdateCartQuantityState> emit) async {
    emit(UpdateCartQuantityState(isLoading: true, isFailed: false));

    final response = await _repository.UpdateCartQuantity(event.data, event.id);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(UpdateCartQuantityState(isCompleted: true, isLoading: false, updateCartQuantityModel: response.data));
    } else {
      emit(UpdateCartQuantityState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
