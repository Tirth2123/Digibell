import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/bloc/update_qr_details_event.dart';
import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/bloc/update_qr_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/update_address_repository.dart';

class UpdateQRDetailsBloc extends Bloc<UpdateQRDetailsEvent, UpdateQRDetailsState> {
  final _repository = GetIt.I<UpdateQRDetailsRepository>();
  UpdateQRDetailsBloc() : super(UpdateQRDetailsState()) {
    on<PerformUpdateQRDetailsEvent>(_perform);
  }
  void _perform(PerformUpdateQRDetailsEvent event, Emitter<UpdateQRDetailsState> emit) async {
    emit(UpdateQRDetailsState(isLoading: true, isFailed: false));

    final response = await _repository.UpdateQRDetails(event.data, event.id);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(UpdateQRDetailsState(isCompleted: true, isLoading: false, updateQRDetailsModel: response.data));
    } else {
      emit(UpdateQRDetailsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
