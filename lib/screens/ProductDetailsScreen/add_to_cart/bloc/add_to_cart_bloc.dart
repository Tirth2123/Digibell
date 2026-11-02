import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/add_to_cart_repository.dart';
import 'add_to_cart_event.dart';
import 'add_to_cart_state.dart';

class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  final _repository = GetIt.I<AddToCartRepository>();
  AddToCartBloc() : super(AddToCartState()) {
    on<PerformAddToCartEvent>(_perform);
  }
  void _perform(PerformAddToCartEvent event, Emitter<AddToCartState> emit) async {
    emit(AddToCartState(isLoading: true, isFailed: false));

    final response = await _repository.AddToCart(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(AddToCartState(isCompleted: true, isLoading: false, addToCartModel: response.data));
    } else {
      emit(AddToCartState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
