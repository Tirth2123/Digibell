import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/purchse_order_event.dart';
import 'package:Digibells/screens/ProductDetailsScreen/product_details/bloc/purchse_order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/purchse_order_repository.dart';

class PurchseOrderBloc extends Bloc<PurchseOrderEvent, PurchseOrderState> {
  final _repository = GetIt.I<PurchseOrderRepository>();
  PurchseOrderBloc() : super(PurchseOrderState()) {
    on<PerformPurchseOrderEvent>(_perform);
  }
  void _perform(PerformPurchseOrderEvent event, Emitter<PurchseOrderState> emit) async {
    emit(PurchseOrderState(isLoading: true, isFailed: false));

    final response = await _repository.purchseOrder(event.data);

    // Print the status of the response
    print('RESPONSE_STATUS: ${response.status}');

    // Print the entire response for debugging
    print('FULL RESPONSE: $response');

    // Check if the response was successful
    if (response.status == ApiStatus.success) {
      // Print the actual data returned by the API
      print('RESPONSE DATA: ${response.data}');

      emit(PurchseOrderState(
        isCompleted: true,
        isLoading: false,
        purchseOrderModel: response.data,
      ));
    } else {
      // Print any errors or error messages
      print('ERROR: ${response.error}');
      print('ERROR MESSAGE: ${response.errorMsg}');

      emit(PurchseOrderState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
