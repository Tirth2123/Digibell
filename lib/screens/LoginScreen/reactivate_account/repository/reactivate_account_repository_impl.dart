import 'package:Digibells/screens/LoginScreen/reactivate_account/repository/reactivate_account_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/reactivate_account_model.dart';

class ReactivateAccountRepositoryImpl extends ReactivateAccountRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<ReactivateAccountModel>> ReactivateAccount(data) async {
    try {
      final response = await _dio.put(APIConstants.reactivateAccount, data: data);
      final newResponse = ReactivateAccountModel.fromJson(response.data);
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
