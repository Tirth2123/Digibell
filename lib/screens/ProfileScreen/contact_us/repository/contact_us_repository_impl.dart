import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/contact_us_model.dart';
import 'contact_us_repository.dart';

class ContactUsRepositoryImpl extends ContactUsRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<ContactUsModel>> ContactUs(data) async {
    try {
      final response = await _dio.post(APIConstants.contactUs, data: data);
      final newResponse = ContactUsModel.fromJson(response.data);
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
