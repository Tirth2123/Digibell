
import 'package:Digibells/screens/SingUP/repository/user_details_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../api_client/api_constans.dart';
import '../../../api_models/api_response.dart';
import '../../../utils/logger.dart';
import '../model/user_details_model.dart';


class UserDetailsRepositoryImpl extends UserDetailsRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<UserDetailsModel>> userDetails(data) async {
    try {
      final response = await _dio.put(APIConstants.userDetails, data: data);
      final newResponse = UserDetailsModel.fromJson(response.data);
      logger.w("THIS IS A REG DATA FROM API ==> ${newResponse.data?.toJson()}");
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
       final response = error.response;
      logger.e('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);
    }
  }
}
