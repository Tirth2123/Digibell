import 'package:Digibells/screens/LoginScreen/repository/guest_user/guest_user_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../../model/guest_user_model.dart';

class GuestUserRepositoryImpl extends GuestUserRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<GuestUserModel>> guestUser() async {
    try {
      final response = await _dio.post(
        APIConstants.guestUser,
      );
      final newResponse = GuestUserModel.fromJson(response.data);
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
