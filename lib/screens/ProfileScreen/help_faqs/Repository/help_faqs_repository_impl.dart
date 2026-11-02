import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/help_faqs_model.dart';
import 'help_faqs_repository.dart';

class HelpFaqsRepositoryImpl extends HelpFaqsRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<HelpFaqsModel>> get() async {
    try {
      final response = await _dio.get(APIConstants.helpFaqs);
      final newResponse = HelpFaqsModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;
      return ApiResponse.error(errorMsg: response == null ? error.message : response.data['message']);
    }
  }
}
