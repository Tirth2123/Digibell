import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/activate_qr_code_repository.dart';
import 'activate_qr_code_event.dart';
import 'activate_qr_code_state.dart';

class ActivateQRCodeBloc extends Bloc<ActivateQRCodeEvent, ActivateQRCodeState> {
  final _repository = GetIt.I<ActivateQRCodeRepository>();
  ActivateQRCodeBloc() : super(ActivateQRCodeState()) {
    on<PerformActivateQRCodeEvent>(_perform);
  }
  void _perform(PerformActivateQRCodeEvent event, Emitter<ActivateQRCodeState> emit) async {
    emit(ActivateQRCodeState(isLoading: true, isFailed: false));

    final response = await _repository.ActivateQRCode(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(ActivateQRCodeState(isCompleted: true, isLoading: false, activateQRCodeModel: response.data));
    } else {
      emit(ActivateQRCodeState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
