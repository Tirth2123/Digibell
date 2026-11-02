import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../api_models/api_error.dart';
import '../../model/delete_account_model.dart';
import '../../repository/delete_account/delete_account_repository.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final _loginRepository = GetIt.I<DeleteAccountRepository>();
  DeleteAccountBloc() : super(DeleteAccountState()) {
    on<PerformDeleteAccountEvent>(_perform);
  }
  void _perform(PerformDeleteAccountEvent event, Emitter<DeleteAccountState> emit) async {
    emit(DeleteAccountState(isLoading: true));
    final response = await _loginRepository.deleteAccount();
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(DeleteAccountState(
          isCompleted: true,
          // from: event.from,
          isLoading: false,
          deleteAccountModel: response.data));
    } else {
      emit(DeleteAccountState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
