import '../../../../api_models/api_response.dart';
import '../../model/data_checks_model.dart';


abstract class DataCheckRepository {
  Future<ApiResponse<DataChecksModel>> checkPhone(dynamic data);
}
