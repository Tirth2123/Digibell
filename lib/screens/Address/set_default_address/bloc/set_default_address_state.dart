


import '../../../../api_models/api_error.dart';
import '../model/set_default_address_model.dart';

class SetDefaultAddressState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final SetDefaultAddressModel? setDefaultAddressModel;

  SetDefaultAddressState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.setDefaultAddressModel});
}
