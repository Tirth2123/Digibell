import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/modify_notification_model.dart';
import 'modify_notification_repository.dart';

class ModifyNotificationRepositoryImpl extends ModifyNotificationRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<ModifyNotificationModel>> get() async {
    try {
      final response = await _dio.put(APIConstants.modifyNotification);
      final newResponse = ModifyNotificationModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      final response = error.response;
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response == null ? error.message : response.data['message']);
    }
  }
}
