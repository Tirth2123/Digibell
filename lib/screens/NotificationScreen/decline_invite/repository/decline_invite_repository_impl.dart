import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../model/decline_invite_model.dart';
import 'decline_invite_repository.dart';

class DeclineInviteRepositoryImpl extends DeclineInviteRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<DeclineInviteModel>> DeclineInvite(id) async {
    try {
      final response = await _dio.put(APIConstants.rejectInvite(id));
      final newResponse = DeclineInviteModel.fromJson(response.data);
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
