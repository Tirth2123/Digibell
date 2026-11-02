import 'package:Digibells/screens/SubscriptionScreen/subscription_details/repository/subscription_details_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/subscription_details_model.dart';

class SubscriptionDetailsRepositoryImpl extends SubscriptionDetailsRepository {
  final _dio = GetIt.I<Dio>();

  @override
  Future<ApiResponse<SubscriptionDetailsModel>> SubscriptionDetails(type, search) async {
    try {
      final response = await _dio.get(APIConstants.subscriptionDetails(type, search));
      final newResponse = SubscriptionDetailsModel.fromJson(response.data);
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
