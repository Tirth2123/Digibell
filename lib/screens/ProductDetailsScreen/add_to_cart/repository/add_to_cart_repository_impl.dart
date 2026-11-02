import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/add_to_cart_model.dart';
import 'add_to_cart_repository.dart';

class AddToCartRepositoryImpl extends AddToCartRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<AddToCartModel>> AddToCart(data) async {
    try {
      final response = await _dio.post(APIConstants.addToCart, data: data);
      final newResponse = AddToCartModel.fromJson(response.data);
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
