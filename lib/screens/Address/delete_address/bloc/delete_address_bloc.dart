import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/delete_address_repository.dart';
import 'delete_address_event.dart';
import 'delete_address_state.dart';

class DeleteAddressBloc extends Bloc<DeleteAddressEvent, DeleteAddressState> {
  final _repository = GetIt.I<DeleteAddressRepository>();
  DeleteAddressBloc() : super(DeleteAddressState()) {
    on<PerformDeleteAddressEvent>(_perform);
  }
  void _perform(PerformDeleteAddressEvent event, Emitter<DeleteAddressState> emit) async {
    emit(DeleteAddressState(isLoading: true, isFailed: false));

    final response = await _repository.DeleteAddress(event.id);
    if (response.status == ApiStatus.success) {
      emit(DeleteAddressState(
        isCompleted: true, isLoading: false,
          deleteAddressModel: response.data
      ));
    } else {
      emit(DeleteAddressState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
