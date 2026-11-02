import 'package:Digibells/screens/HomeScreen/update_qr_status/bloc/update_qr_status_event.dart';
import 'package:Digibells/screens/HomeScreen/update_qr_status/bloc/update_qr_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/update_qr_status_repository.dart';

class UpdateQRStatusBloc extends Bloc<UpdateQRStatusEvent, UpdateQRStatusState> {
  final _repository = GetIt.I<UpdateQRStatusRepository>();
  UpdateQRStatusBloc() : super(UpdateQRStatusState()) {
    on<PerformUpdateQRStatusEvent>(_perform);
  }
  void _perform(PerformUpdateQRStatusEvent event, Emitter<UpdateQRStatusState> emit) async {
    emit(UpdateQRStatusState(isLoading: true, isFailed: false));

    final response = await _repository.UpdateQRStatus(event.id);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(UpdateQRStatusState(isCompleted: true, isLoading: false, updateQRStatusModel: response.data));
    } else {
      emit(UpdateQRStatusState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
