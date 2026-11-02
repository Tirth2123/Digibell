import 'package:Digibells/screens/Address/set_default_address/bloc/set_default_address_event.dart';
import 'package:Digibells/screens/Address/set_default_address/bloc/set_default_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/set_default_address_repository.dart';


class SetDefaultAddressBloc extends Bloc<SetDefaultAddressEvent, SetDefaultAddressState> {
  final _repository = GetIt.I<SetDefaultAddressRepository>();
  SetDefaultAddressBloc() : super(SetDefaultAddressState()) {
    on<PerformSetDefaultAddressEvent>(_perform);
  }
  void _perform(PerformSetDefaultAddressEvent event, Emitter<SetDefaultAddressState> emit) async {
    emit(SetDefaultAddressState(isLoading: true, isFailed: false));

    final response = await _repository.SetDefaultAddress(event.id);
    if (response.status == ApiStatus.success) {
      emit(SetDefaultAddressState(
        isCompleted: true, isLoading: false,
          setDefaultAddressModel: response.data
      ));
    } else {
      emit(SetDefaultAddressState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
