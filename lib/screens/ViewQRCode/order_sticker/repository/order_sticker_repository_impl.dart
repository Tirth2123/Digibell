import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../../utils/logger.dart';
import '../model/order_sticker_model.dart';
import 'order_sticker_repository.dart';

class OrderStickerRepositoryImpl extends OrderStickerRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<OrderStickerModel>> OrderSticker(data) async {
    try {
      final response = await _dio.post(APIConstants.orderSticker, data: data);
      final newResponse = OrderStickerModel.fromJson(response.data);
      return ApiResponse.success(data: newResponse);
    } on DioError catch (error) {
      logger.e('MYERRORR $error');
      //return ApiResponse.error(error: ApiUtils.getApiError(error));
      final response = error.response;

      logger.e('RESPONSE_ERRRORR ${error.response}');
      logger.e('RESPONSE_ERRRORR ${response!.data['message']}');
      return ApiResponse.error(errorMsg: response.data['message']);
    }
  }
}
