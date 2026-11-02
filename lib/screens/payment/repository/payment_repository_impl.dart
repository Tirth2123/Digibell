import 'package:Digibells/screens/payment/repository/payment_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../../utils/logger.dart';
import '../model/payment_model.dart';


class PaymentRepositoryImpl extends PaymentRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<PaymentModel>> Payment(data) async {
    try {
      final response = await _dio.post(APIConstants.payment, data: data);
      final newResponse = PaymentModel.fromJson(response.data);
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
