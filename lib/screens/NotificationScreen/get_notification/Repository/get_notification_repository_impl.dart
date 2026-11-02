import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/get_notification_model.dart';
import 'get_notification_repository.dart';

class GetNotificationsRepositoryImpl extends GetNotificationsRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<GetNotificationsModel>> get() async {
    try {
      final response = await _dio.get(APIConstants.getNotification);
      final newResponse = GetNotificationsModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      final response = error.response;
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response == null ? error.message : response.data['message']);
    }
  }
}
