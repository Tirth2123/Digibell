
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_models/api_error.dart';
import '../../../../api_models/api_status.dart';
import '../../model/update_profile_model.dart';
import '../../repository/upadte_profile/update_profile_repository.dart';

part 'update_profile_event.dart';
part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final _repository = GetIt.I<UpdateProfileRepository>();
  UpdateProfileBloc() : super(UpdateProfileState()) {
    on<PerformUpdateProfileEvent>(_perform);
  }
  void _perform(PerformUpdateProfileEvent event, Emitter<UpdateProfileState> emit) async {
    emit(UpdateProfileState(isLoading: true, isFailed: false));

    final response = await _repository.updateProfile(event.data);
    print('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      print('REPONSE_STATUS ${response.status}');
      emit(UpdateProfileState(
        isCompleted: true, isLoading: false,
        updateProfileModel: response.data
      ));
    } else {
      emit(UpdateProfileState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
