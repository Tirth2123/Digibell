import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/activate_qr_code_model.dart';
import 'activate_qr_code_repository.dart';

class ActivateQRCodeRepositoryImpl extends ActivateQRCodeRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<ActivateQRCodeModel>> ActivateQRCode(data) async {
    try {
      final response = await _dio.put(APIConstants.activateQRCode, data: data);
      final newResponse = ActivateQRCodeModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      print('RESPONSE_ERRRORR ${error.response}');
      print('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);
    }
  }
}
