import 'package:Digibells/screens/shopping_cart/update_cart_quantity/repository/update_cart_quantity_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_client/api_utils.dart';
import '../../../../api_models/api_response.dart';
import '../model/update_cart_quantity_model.dart';

class UpdateCartQuantityRepositoryImpl extends UpdateCartQuantityRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<UpdateCartQuantityModel>> UpdateCartQuantity(data, id) async {
    try {
      final response = await _dio.put(APIConstants.updateCartQuantity(id), data: data);
      final newResponse = UpdateCartQuantityModel.fromJson(response.data);
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
