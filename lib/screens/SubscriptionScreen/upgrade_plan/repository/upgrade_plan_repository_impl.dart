import 'package:Digibells/screens/SubscriptionScreen/upgrade_plan/repository/upgrade_plan_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../model/upgrade_plan_model.dart';

class UpgradePlanRepositoryImpl extends UpgradePlanRepository {
  final _dio = GetIt.I<Dio>();
  @override
  Future<ApiResponse<UpgradePlanModel>> UpgradePlan(data) async {
    try {
      final response = await _dio.post(APIConstants.upgradePlan, data: data);
      final newResponse = UpgradePlanModel.fromJson(response.data);
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
