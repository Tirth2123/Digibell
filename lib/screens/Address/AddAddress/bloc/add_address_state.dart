
import '../../../../api_models/api_error.dart';
import '../model/add_address_model.dart';

class AddAddressState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final AddAddressModel? addAddressModel;

  AddAddressState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.addAddressModel});
}
