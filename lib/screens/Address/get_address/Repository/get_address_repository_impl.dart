import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
 import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/GetAddressModel.dart';
import 'get_address_repository.dart';

class GetAddressRepositoryImpl extends GetAddressRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<GetAllAddressModel>> get() async {
    try {
      final response = await _dio.get(APIConstants.getAllAddress);
      final newResponse = GetAllAddressModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
       final response = error.response;
       logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(
          errorMsg:
              response == null ? error.message : response.data['message']);
    }
  }
}
