import 'package:Digibells/screens/LoginScreen/reactivate_account/bloc/reactivate_account_event.dart';
import 'package:Digibells/screens/LoginScreen/reactivate_account/bloc/reactivate_account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/reactivate_account_repository.dart';

class ReactivateAccountBloc extends Bloc<ReactivateAccountEvent, ReactivateAccountState> {
  final _repository = GetIt.I<ReactivateAccountRepository>();
  ReactivateAccountBloc() : super(ReactivateAccountState()) {
    on<PerformReactivateAccountEvent>(_perform);
  }
  void _perform(PerformReactivateAccountEvent event, Emitter<ReactivateAccountState> emit) async {
    emit(ReactivateAccountState(isLoading: true, isFailed: false));

    final response = await _repository.ReactivateAccount(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(ReactivateAccountState(isCompleted: true, isLoading: false, reactivateAccountModel: response.data));
    } else {
      emit(ReactivateAccountState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
