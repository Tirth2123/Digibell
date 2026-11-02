import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../api_models/api_status.dart';
import '../repository/add_qr_details_repository.dart';
import 'add_qr_details_event.dart';
import 'add_qr_details_state.dart';

class AddQRDetailsBloc extends Bloc<AddQRDetailsEvent, AddQRDetailsState> {
  final _repository = GetIt.I<AddQRDetailsRepository>();
  AddQRDetailsBloc() : super(AddQRDetailsState()) {
    on<PerformAddQRDetailsEvent>(_perform);
  }
  void _perform(PerformAddQRDetailsEvent event, Emitter<AddQRDetailsState> emit) async {
    emit(AddQRDetailsState(isLoading: true, isFailed: false));

    final response = await _repository.AddQRDetails(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(AddQRDetailsState(isCompleted: true, isLoading: false, addQRDetailsModel: response.data));
    } else {
      emit(AddQRDetailsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
