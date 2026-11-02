import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/call_history_model.dart';
import 'call_history_repository.dart';

class CallHistoryRepositoryImpl extends CallHistoryRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<CallHistoryModel>> get() async {
    try {
      final response = await _dio.get(APIConstants.callHistory);
      final newResponse = CallHistoryModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
      final response = error.response;
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response == null ? error.message : response.data['message']);
    }
  }
}
