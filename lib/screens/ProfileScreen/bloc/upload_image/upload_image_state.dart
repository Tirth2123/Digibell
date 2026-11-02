part of 'upload_image_bloc.dart';

@immutable
class UploadImageState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final int? type;
  final bool isFailed;
  final UploadImageModel? uploadImageModel;

  UploadImageState(
      {this.isLoading = false,
      this.type,
      this.error,
      this.errorMsg = '',
      this.isCompleted = false,
      this.isFailed = false,
      this.uploadImageModel});
}
