 import 'package:Digibells/screens/Address/set_default_address/repository/set_default_address_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/set_default_address_model.dart';


class SetDefaultAddressRepositoryImpl extends SetDefaultAddressRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<SetDefaultAddressModel>> SetDefaultAddress(id) async {
    try {
      final response = await _dio.put(APIConstants.defaultAddress(id));
      final newResponse = SetDefaultAddressModel.fromJson(response.data);
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
