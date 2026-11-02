 import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/delete_address_model.dart';
import 'delete_address_repository.dart';

class DeleteAddressRepositoryImpl extends DeleteAddressRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<DeleteAddressModel>> DeleteAddress(id) async {
    try {
      final response = await _dio.delete(APIConstants.deleteAddress(id));
      final newResponse = DeleteAddressModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
       final response = error.response;
      logger.e('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg:response == null ? error.message : response.data['message']);
    }
  }
}
