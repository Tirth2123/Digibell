import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_all_qr_details_repository.dart';
import 'get_all_qr_details_event.dart';
import 'get_all_qr_details_state.dart';

class GetAllQRDetailsBloc extends Bloc<GetAllQRDetailsEvent, GetAllQRDetailsState> {
  final _repository = GetIt.I<GetAllQRDetailsRepository>();
  GetAllQRDetailsBloc() : super(GetAllQRDetailsState()) {
    on<PerformGetAllQRDetailsEvent>(_perform);
  }

  void _perform(PerformGetAllQRDetailsEvent event, Emitter<GetAllQRDetailsState> emit) async {
    emit(GetAllQRDetailsState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetAllQRDetailsState(isCompleted: true, isLoading: false, getAllQRDetailsModel: response.data));
    } else {
      emit(GetAllQRDetailsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
