import 'dart:async';

import 'package:bloc/bloc.dart';
 import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../api_models/api_error.dart';
import '../../../../api_models/api_status.dart';
import '../../model/upload_image_model.dart';
import '../../repository/upload_image/upload_image_repository.dart';


part 'upload_image_event.dart';
part 'upload_image_state.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  final _repository = GetIt.I<UploadImageRepository>();
  UploadImageBloc() : super(UploadImageState()) {
    on<PerformUploadImageEvent>(_perform);
  }
  void _perform(PerformUploadImageEvent event, Emitter<UploadImageState> emit) async {
    emit(UploadImageState(isLoading: true, isFailed: false));

    final response = await _repository.uploadImage(event.data);
    if (response.status == ApiStatus.success) {
      emit(UploadImageState(isCompleted: true, isLoading: false, uploadImageModel: response.data,));
    } else {
      emit(UploadImageState(
        error: response.error,
        errorMsg: response.errorMsg,
        isFailed: true,
        isLoading: false,
        isCompleted: false,
      ));
    }
  }
}
