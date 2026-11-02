import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/repository/update_address_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../model/update_qr_details_model.dart';

class UpdateQRDetailsRepositoryImpl extends UpdateQRDetailsRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<UpdateQRDetailsModel>> UpdateQRDetails(data, id) async {
    try {
      final response = await _dio.put(APIConstants.updateQRDetails(id), data: data);
      final newResponse = UpdateQRDetailsModel.fromJson(response.data);
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
