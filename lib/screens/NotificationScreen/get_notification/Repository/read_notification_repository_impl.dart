

import 'package:Digibells/api_client/api_constans.dart';
import 'package:Digibells/api_models/api_response.dart';
import 'package:Digibells/screens/NotificationScreen/get_notification/Repository/read_notification_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ReadNotificationsRepositoryImpl extends ReadNotificationsRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<Map>> readNotification() async {
    try {
      final response = await _dio.put(APIConstants.readNotification);

      return ApiResponse.success(data: response.data);
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