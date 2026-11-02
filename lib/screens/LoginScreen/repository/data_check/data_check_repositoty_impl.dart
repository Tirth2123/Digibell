import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../model/data_checks_model.dart';
import 'data_check_repository.dart';

class DataCheckRepositoryImpl extends DataCheckRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<DataChecksModel>> checkPhone(dynamic data) async {
    try {
       final response = await _dio.get(
        "${APIConstants.dataCheck}?mobileNumber=$data",
      );
      var newResponse = DataChecksModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioException catch (error) {
      print('MYERRORR $error');
      // Handle the error based on the type of error
      if (error.response != null) {
        final response = error.response;
        print('RESPONSE_ERRRORR ${error.response}');
        print('RESPONSE_ERRRORR ${response!.data['message']}');
        return ApiResponse.error(errorMsg: response.data['message']);
      } else {
        // Handle other types of Dio errors like connectivity issues
        print('RESPONSE_ERRRORR ${error.message}');
        return ApiResponse.error(errorMsg: error.message);
      }
    } catch (e) {
      // Handle any other types of errors
      print('UNEXPECTED_ERROR $e');
      return ApiResponse.error(errorMsg: 'An unexpected error occurred');
    }
  }
}

