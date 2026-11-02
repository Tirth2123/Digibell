import 'package:Digibells/screens/shopping_cart/remove_cart_item/repository/remove_cart_item_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/remove_cart_item_model.dart';

class RemoveCartItemRepositoryImpl extends RemoveCartItemRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<RemoveCartItemModel>> RemoveCartItem(id) async {
    try {
      final response = await _dio.delete(APIConstants.removeCartItem(id));
      final newResponse = RemoveCartItemModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      print('MYERRORR $error');
      final response = error.response;
      print('RESPONSE_ERRRORR ${error.response}');
      print('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response == null ? error.message : response.data['message']);
    }
  }
}
