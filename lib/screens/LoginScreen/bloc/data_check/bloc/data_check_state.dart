part of 'data_check_bloc.dart';

@immutable
class DataCheckState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final String? from;
  final bool isCompleted;
  final bool isFailed;
  final int? statusCode;
  final DataChecksModel? model;

  DataCheckState(
      {this.isLoading = false,
        this.error,
        this.from,
        this.errorMsg = '',
        this.isCompleted = false,
        this.isFailed = false,
        this.statusCode,
        this.model});
}
