
 import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../api_models/api_error.dart';
import '../../../api_models/api_status.dart';


import '../../../utils/logger.dart';
import '../model/user_details_model.dart';
import '../repository/register_repository.dart';
import '../repository/user_details_repository.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final _repository = GetIt.I<UserDetailsRepository>();
  UserDetailsBloc() : super(UserDetailsState()) {
    on<PerformUserDetailsEvent>(_perform);
  }
  void _perform(PerformUserDetailsEvent event, Emitter<UserDetailsState> emit) async {
    emit(UserDetailsState(isLoading: true, isFailed: false));

    final response = await _repository.userDetails(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');

      emit(UserDetailsState(
          isCompleted: true, isLoading: false, userDetailsModel: response.data

      ));
    } else {
      emit(UserDetailsState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
