import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/bloc/upgrade_plan_event.dart';
import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/bloc/upgrade_plan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_models/api_status.dart';
import '../repository/upgrade_plan_repository.dart';

class UpgradePlanBloc extends Bloc<UpgradePlanEvent, UpgradePlanState> {
  final _repository = GetIt.I<UpgradePlanRepository>();
  UpgradePlanBloc() : super(UpgradePlanState()) {
    on<PerformUpgradePlanEvent>(_perform);
  }
  void _perform(PerformUpgradePlanEvent event, Emitter<UpgradePlanState> emit) async {
    emit(UpgradePlanState(isLoading: true, isFailed: false));

    final response = await _repository.UpgradePlan(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(UpgradePlanState(isCompleted: true, isLoading: false, upgradePlanModel: response.data));
    } else {
      emit(UpgradePlanState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
