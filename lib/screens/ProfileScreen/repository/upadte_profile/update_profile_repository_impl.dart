import 'package:Digibells/screens/ProfileScreen/repository/upadte_profile/update_profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../model/update_profile_model.dart';

class UpdateProfileRepositoryImpl extends UpdateProfileRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<UpdateProfileModel>> updateProfile(data) async {
    try {
      final response = await _dio.put(APIConstants.updateProfile, data: data);
      final newResponse = UpdateProfileModel.fromJson(response.data);
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
