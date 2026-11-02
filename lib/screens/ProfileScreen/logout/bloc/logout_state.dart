
import 'package:Digibells/screens/ProfileScreen/logout/model/logout_model.dart';

import '../../../../api_models/api_error.dart';

class LogoutState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final LogoutModel? logoutModel;

  LogoutState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.logoutModel,
  });
}
