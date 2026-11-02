
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_models/api_error.dart';
import '../../../../api_models/api_status.dart';
import '../../../../utils/logger.dart';
import '../repository/add_address_repository.dart';
import 'add_address_event.dart';
import 'add_address_state.dart';


class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final _repository = GetIt.I<AddAddressRepository>();
  AddAddressBloc() : super(AddAddressState()) {
    on<PerformAddAddressEvent>(_perform);
  }
  void _perform(PerformAddAddressEvent event, Emitter<AddAddressState> emit) async {
    emit(AddAddressState(isLoading: true, isFailed: false));

    final response = await _repository.addAddress(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(AddAddressState(
        isCompleted: true, isLoading: false,
        // UserDetailsModel: response.data
      ));
    } else {
      emit(AddAddressState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
