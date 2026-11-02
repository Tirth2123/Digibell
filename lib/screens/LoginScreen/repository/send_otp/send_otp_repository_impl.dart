

import 'package:Digibells/screens/LoginScreen/model/send_otp.dart';
import 'package:Digibells/screens/LoginScreen/repository/send_otp/send_otp_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';

class SendOtpRepositoryImpl extends SendOtpRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<SendOtp>> sendOtp(data) async {
    try {
      final response = await _dio.post(
        // "${APIConstants.login}$data",
          APIConstants.sendOTP, data: data
      );
      final newResponse = SendOtp.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      logger.e('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);
    }
  }
}