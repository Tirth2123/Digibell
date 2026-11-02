import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/get_all_qr_details_model.dart';
import 'get_all_qr_details_repository.dart';

class GetAllQRDetailsRepositoryImpl extends GetAllQRDetailsRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<GetAllQRDetailsModel>> get() async {
    try {
      final response = await _dio.get(APIConstants.getAllQR);
      final newResponse = GetAllQRDetailsModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
      final response = error.response;
      logger.w('RESPONSE_ERRRORR ${error.response}');
      logger.w('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);    }
  }
}
