part of 'delete_account_bloc.dart';



class DeleteAccountState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final String? from;
  final bool isCompleted;
  final bool isFailed;
  final int? statusCode;
  final DeleteAccountModel? deleteAccountModel;

  DeleteAccountState(
      {this.isLoading = false,
        this.error,
        this.from,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.statusCode,
        this.deleteAccountModel});
}

