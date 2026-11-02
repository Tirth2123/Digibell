import 'package:Digibells/screens/ProfileScreen/repository/upload_image/upload_image_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../model/upload_image_model.dart';

class UploadImageRepositoryImpl extends UploadImageRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<UploadImageModel>> uploadImage(dynamic data) async {
    try {
      final response;
      if (data == 'image') {
        response = await _dio.post(APIConstants.uploadImage, data: data);
      } else {
        response = await _dio.post(APIConstants.uploadImage, data: data);
      }
      final newsResponse = UploadImageModel.fromJson(response.data);
      return ApiResponse.success(data: newsResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      final response = error.response;
      return ApiResponse.error(errorMsg: response!.data['message']);
    }
  }
}
