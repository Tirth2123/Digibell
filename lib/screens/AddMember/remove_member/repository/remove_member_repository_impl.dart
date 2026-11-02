import 'package:Digibells/screens/AddMember/remove_member/repository/remove_member_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/remove_member_model.dart';

class RemoveMemberRepositoryImpl extends RemoveMemberRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<RemoveMemberModel>> RemoveMember(id) async {
    try {
      final response = await _dio.delete(APIConstants.removeMember(id));
      final newResponse = RemoveMemberModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      print('RESPONSE_ERRRORR ${error.response}');
      print('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);
      // final response = error.response;
      //
      // print('RESPONSE_ERRRORR ${error.response}');
      // print('RESPONSE_ERRRORR ${response!.data['message']}');
      // return ApiResponse.error(errorMsg: response.data['message']);
    }
  }
}
