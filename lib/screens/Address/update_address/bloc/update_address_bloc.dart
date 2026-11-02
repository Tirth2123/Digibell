import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../model/update_address_model.dart';
import '../repository/update_address_repository.dart';

part 'update_address_event.dart';
part 'update_address_state.dart';

class UpdateAddressBloc extends Bloc<UpdateAddressEvent, UpdateAddressState> {
  final _repository = GetIt.I<UpdateAddressRepository>();
  UpdateAddressBloc() : super(UpdateAddressState()) {
    on<PerformUpdateAddressEvent>(_perform);
  }
  void _perform(PerformUpdateAddressEvent event, Emitter<UpdateAddressState> emit) async {
    emit(UpdateAddressState(isLoading: true, isFailed: false));

    final response = await _repository.updateAddress(event.data, event.id);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(UpdateAddressState(isCompleted: true, isLoading: false, updateAddressModel: response.data));
    } else {
      emit(UpdateAddressState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
