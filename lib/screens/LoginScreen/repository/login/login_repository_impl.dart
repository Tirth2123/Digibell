
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../../model/login_model.dart';
import 'login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<LoginModel>> login(data) async {
    try {
      final response = await _dio.post(
        // "${APIConstants.login}$data",

        APIConstants.login, data: data
      );
      final newResponse = LoginModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      logger.e('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);
    }
  }
}
