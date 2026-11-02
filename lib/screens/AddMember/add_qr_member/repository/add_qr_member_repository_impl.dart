import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/add_qr_member_model.dart';
import 'add_qr_member_repository.dart';

class AddQRMemberRepositoryImpl extends AddQRMemberRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<AddQRMemberModel>> AddQRMember(data, id) async {
    try {
      final response = await _dio.put(APIConstants.addQRMembers(id), data: data);
      final newResponse = AddQRMemberModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR ${error.response!.data['message']}');
      return ApiResponse.error(errorMsg: error.response!.data['message']);
    }
  }
}
