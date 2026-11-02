import '../../../../api_models/api_response.dart';
import '../model/update_qr_status_model.dart';

abstract class UpdateQRStatusRepository {
  Future<ApiResponse<UpdateQRStatusModel>> UpdateQRStatus(dynamic id);
}
