part of 'get_address_bloc.dart';

class GetAddressScreenState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final GetAllAddressModel? getAllAddressModel;

  GetAddressScreenState({
    this.isLoading = false,
    this.error,
    this.errorMsg = '',
    this.isCompleted = false,
    this.isFailed = false,
    this.getAllAddressModel,
  });
}
