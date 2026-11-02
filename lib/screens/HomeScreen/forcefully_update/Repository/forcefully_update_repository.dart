import '../../../../api_models/api_response.dart';
import '../model/forcefully_update_model.dart';

abstract class ForcefullyUpdateRepository {
  Future<ApiResponse<ForcefullyUpdateModel>> get();
}
