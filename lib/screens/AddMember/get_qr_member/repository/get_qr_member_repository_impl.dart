import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/get_qr_member_model.dart';
import 'get_qr_member_repository.dart';


class GetQRMemberRepositoryImpl extends GetQRMemberRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<GetQRMemberModel>> GetQRMember(  id) async {
    try {
      final response = await _dio.get(APIConstants.getQRMembers(id) );
      final newResponse = GetQRMemberModel.fromJson(response.data);
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
