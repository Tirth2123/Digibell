import 'package:Digibells/screens/LoginScreen/repository/social_login/social_login_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../helper/api_base_helper.dart';
import '../../model/login_model.dart';



class SocialLoginRepositoryImpl extends SocialLoginRepository {
  ApiBaseHelper? _helper = ApiBaseHelper();
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<LoginModel>> socialLogin(data) async {
    try {
      final response = await _dio.post(APIConstants.socialLoginUrl, data: data);
      final newsResponse = LoginModel.fromJson(response.data);
      return ApiResponse.success(data: newsResponse);
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
