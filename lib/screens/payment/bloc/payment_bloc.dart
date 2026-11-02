import 'package:Digibells/screens/payment/bloc/payment_event.dart';
import 'package:Digibells/screens/payment/bloc/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../utils/logger.dart';
import '../repository/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final _repository = GetIt.I<PaymentRepository>();
  PaymentBloc() : super(PaymentState()) {
    on<PerformPaymentEvent>(_perform);
  }
  void _perform(PerformPaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentState(isLoading: true, isFailed: false));

    final response = await _repository.Payment(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(PaymentState(isCompleted: true, isLoading: false, paymentModel: response.data));
    } else {
      emit(PaymentState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
