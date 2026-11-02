import 'package:Digibells/screens/ProductDetailsScreen/product_details/repository/product_details_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api_client/api_constans.dart';
import '../../../../../api_models/api_response.dart';
import '../model/product_details_model.dart';

class ProductDetailsRepositoryImpl extends ProductDetailsRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<ProductDetailsModel>> productDetails(id) async {
    try {
      final response = await _dio.get(
        "${APIConstants.productDetails}$id/v1",
      );
      var newResponse = ProductDetailsModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioException catch (error) {
      print('MYERRORR $error');

      if (error.response != null) {
        final response = error.response;
        print('RESPONSE_ERRRORR ${error.response}');
        print('RESPONSE_ERRRORR ${response!.data['message']}');
        return ApiResponse.error(errorMsg: response.data['message']);
      } else {
        print('RESPONSE_ERRRORR ${error.message}');
        return ApiResponse.error(errorMsg: error.message);
      }
    } catch (e) {
      print('UNEXPECTED_ERROR $e');
      return ApiResponse.error(errorMsg: 'An unexpected error occurred');
    }
  }
}
