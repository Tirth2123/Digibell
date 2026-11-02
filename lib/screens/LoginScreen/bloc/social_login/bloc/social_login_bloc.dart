import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../api_models/api_error.dart';
import '../../../../../api_models/api_status.dart';
import '../../../../../utils/logger.dart';
import '../../../model/login_model.dart';
import '../../../repository/social_login/social_login_repository.dart';


part 'social_login_event.dart';
part 'social_login_state.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvent, SocialLoginState> {
  final _loginRepository = GetIt.I<SocialLoginRepository>();
  SocialLoginBloc() : super(SocialLoginState()) {
    on<PerformSocialLoginEvent>(_performSignup);
  }
  void _performSignup(PerformSocialLoginEvent event, Emitter<SocialLoginState> emit) async {
    emit(SocialLoginState(isLoading: true));
    final response = await _loginRepository.socialLogin(event.data);
    logger.w('REPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.w('REPONSE_STATUS ${response.status}');
      emit(SocialLoginState(
        isCompleted: true,
        isLoading: false,
        model: response.data,
      ));
    } else {
      emit(SocialLoginState(
          error: response.error,
          errorMsg: response.errorMsg,
          isFailed: true,
          isLoading: false,
          isCompleted: false,
          email: event.data['email']
      ));
    }
  }
}
