import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/forcefully_update_model.dart';
import 'forcefully_update_repository.dart';

class ForcefullyUpdateRepositoryImpl extends ForcefullyUpdateRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<ForcefullyUpdateModel>> get() async {
    try {
      final response = await _dio.get(APIConstants.forcefullyUpdate);
      final newResponse = ForcefullyUpdateModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
      final response = error.response;
      logger.e('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['messsage']}');
      return ApiResponse.error(errorMsg: response.data['messsage']);    }
  }
}
