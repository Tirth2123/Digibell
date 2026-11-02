import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/add_member_model.dart';
import 'add_member_repository.dart';

class AddMemberRepositoryImpl extends AddMemberRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<AddMemberModel>> AddMember(data) async {
    try {
      final response = await _dio.post(APIConstants.addMembers, data: data);
      final newResponse = AddMemberModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.w('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      logger.w('RESPONSE_ERRRORR ${error.response}');
      logger.w('RESPONSE_ERRRORR ${response!.data['messsage']}');
      return ApiResponse.error(errorMsg: response.data['messsage']);
    }
  }
}
