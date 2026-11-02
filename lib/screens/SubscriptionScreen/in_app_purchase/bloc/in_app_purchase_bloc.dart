import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/in_app_purchase_repository.dart';
import 'in_app_purchase_event.dart';
import 'in_app_purchase_state.dart';

class InAppPurchaseBloc extends Bloc<InAppPurchaseEvent, InAppPurchaseState> {
  final _repository = GetIt.I<InAppPurchaseRepository>();
  InAppPurchaseBloc() : super(InAppPurchaseState()) {
    on<PerformInAppPurchaseEvent>(_perform);
  }
  void _perform(PerformInAppPurchaseEvent event, Emitter<InAppPurchaseState> emit) async {
    emit(InAppPurchaseState(isLoading: true, isFailed: false));

    final response = await _repository.InAppPurchase(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(InAppPurchaseState(isCompleted: true, isLoading: false, inAppPurchaseModel: response.data));
    } else {
      emit(InAppPurchaseState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
