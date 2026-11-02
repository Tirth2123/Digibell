import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../utils/logger.dart';
import '../../../../api_models/api_error.dart';
import '../../../../api_models/api_status.dart';
import '../Repository/get_address_repository.dart';
import '../model/GetAddressModel.dart';
part 'get_address_event.dart';
part 'get_address_state.dart';

class GetAddressScreenBloc extends Bloc<GetAddressScreenEvent, GetAddressScreenState> {
  final _repository = GetIt.I<GetAddressRepository>();
  GetAddressScreenBloc() : super(GetAddressScreenState()) {
    on<PerformGetAddressScreenEvent>(_perform);
  }

  void _perform(PerformGetAddressScreenEvent event, Emitter<GetAddressScreenState> emit) async {
    emit(GetAddressScreenState(isLoading: true, isFailed: false));
    final response = await _repository.get();
    logger.w('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('RESPONSE_STATUS ${response.status}');
      emit(GetAddressScreenState(isCompleted: true, isLoading: false, getAllAddressModel: response.data));
    } else {
      emit(GetAddressScreenState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
