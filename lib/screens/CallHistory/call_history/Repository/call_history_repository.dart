import '../../../../api_models/api_response.dart';
import '../model/call_history_model.dart';

abstract class CallHistoryRepository {
  Future<ApiResponse<CallHistoryModel>> get();
}
