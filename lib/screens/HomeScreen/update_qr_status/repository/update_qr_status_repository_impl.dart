import 'package:Digibells/screens/HomeScreen/update_qr_status/repository/update_qr_status_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/update_qr_status_model.dart';

class UpdateQRStatusRepositoryImpl extends UpdateQRStatusRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<UpdateQRStatusModel>> UpdateQRStatus(id) async {
    try {
      final response = await _dio.put(APIConstants.updateQRStatus(id));
      final newResponse = UpdateQRStatusModel.fromJson(response.data);
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
