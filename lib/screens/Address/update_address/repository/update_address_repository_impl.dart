import 'package:Digibells/screens/Address/update_address/repository/update_address_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/update_address_model.dart';

class UpdateAddressRepositoryImpl extends UpdateAddressRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<UpdateAddressModel>> updateAddress(data, id) async {
    try {
      final response = await _dio.put(APIConstants.updateAddress(id), data: data);
      final newResponse = UpdateAddressModel.fromJson(response.data);
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
