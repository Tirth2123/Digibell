


import '../../../../api_models/api_error.dart';
import '../model/delete_address_model.dart';

class DeleteAddressState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final DeleteAddressModel? deleteAddressModel;

  DeleteAddressState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.deleteAddressModel});
}
