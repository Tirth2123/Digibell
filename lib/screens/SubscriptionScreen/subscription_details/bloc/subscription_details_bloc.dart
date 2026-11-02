import 'package:Digibells/screens/SubscriptionScreen/subscription_details/bloc/subscription_details_event.dart';
import 'package:Digibells/screens/SubscriptionScreen/subscription_details/bloc/subscription_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_models/api_status.dart';
import '../repository/subscription_details_repository.dart';

class SubscriptionDetailsBloc extends Bloc<SubscriptionDetailsEvent, SubscriptionDetailsState> {
  final _repository = GetIt.I<SubscriptionDetailsRepository>();
  SubscriptionDetailsBloc() : super(SubscriptionDetailsState()) {
    on<PerformSubscriptionDetailsEvent>(_perform);
  }
  void _perform(PerformSubscriptionDetailsEvent event, Emitter<SubscriptionDetailsState> emit) async {
    emit(SubscriptionDetailsState(isLoading: true, isFailed: false));

    final response = await _repository.SubscriptionDetails(event.type, event.search);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(SubscriptionDetailsState(isCompleted: true, isLoading: false, subscriptionDetailsModel: response.data));
    } else {
      emit(SubscriptionDetailsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
