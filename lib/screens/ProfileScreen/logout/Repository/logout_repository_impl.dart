import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/alert_utils.dart';
import '../../../../utils/logger.dart';
import '../model/logout_model.dart';
import 'logout_repository.dart';

class LogoutRepositoryImpl extends LogoutRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<LogoutModel>> add(data) async {
    try {
      final response = await _dio.post(APIConstants.logout, data: data);
      final newResponse = LogoutModel.fromJson(response.data);

      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      //print('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response == null ? error.message : response.data['message']);
    }
  }
}
