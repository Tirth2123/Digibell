import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_client/api_constans.dart';
import '../../../../../api_models/api_response.dart';
import '../../model/delete_account_model.dart';
import 'delete_account_repository.dart';

class DeleteAccountRepositoryImpl extends DeleteAccountRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<DeleteAccountModel>> deleteAccount() async {
    try {

      final response = await _dio.delete(
        APIConstants.deleteAccount,
      );
      var newResponse = DeleteAccountModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioException catch (error) {
      print('MYERRORR $error');

      if (error.response != null) {
        final response = error.response;
        print('RESPONSE_ERRRORR ${error.response}');
        print('RESPONSE_ERRRORR ${response!.data['message']}');
        return ApiResponse.error(errorMsg: response.data['message']);
      } else {
        print('RESPONSE_ERRRORR ${error.message}');
        return ApiResponse.error(errorMsg: error.message);
      }
    } catch (e) {
      print('UNEXPECTED_ERROR $e');
      return ApiResponse.error(errorMsg: 'An unexpected error occurred');
    }
  }
}
