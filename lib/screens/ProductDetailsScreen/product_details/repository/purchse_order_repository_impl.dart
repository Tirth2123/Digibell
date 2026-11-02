import 'package:Digibells/screens/ProductDetailsScreen/product_details/repository/purchse_order_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/purchse_order_model.dart';

class PurchseOrderRepositoryImpl extends PurchseOrderRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<PurchseOrderModel>> purchseOrder(data) async {
    try {
      final response = await _dio.post(APIConstants.purchseOrder, data: data);
      final newResponse = PurchseOrderModel.fromJson(response.data);
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
