part of 'update_address_bloc.dart';



class UpdateAddressState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final UpdateAddressModel? updateAddressModel;

  UpdateAddressState(
      {this.isLoading = false,
        this.error,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.updateAddressModel});
}
