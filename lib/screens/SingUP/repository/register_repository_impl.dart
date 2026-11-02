
import 'package:Digibells/screens/SingUP/repository/register_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../api_client/api_constans.dart';
import '../../../api_client/api_utils.dart';
import '../../../api_models/api_response.dart';
import '../../../utils/logger.dart';
import '../model/register_model.dart';


class RegisterRepositoryImpl extends RegisterRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<RegisterModel>> register(data) async {
    try {
      final response = await _dio.post(APIConstants.register, data: data);
      final newResponse = RegisterModel.fromJson(response.data);
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
