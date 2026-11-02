import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/add_qr_details_model.dart';
import 'add_qr_details_repository.dart';

class AddQRDetailsRepositoryImpl extends AddQRDetailsRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<AddQRDetailsModel>> AddQRDetails(data) async {
    try {
      final response = await _dio.post(
          // "${APIConstants.AddQRDetails}$data",

          APIConstants.addQRDetails,
          data: data);
      final newResponse = AddQRDetailsModel.fromJson(response.data);
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
