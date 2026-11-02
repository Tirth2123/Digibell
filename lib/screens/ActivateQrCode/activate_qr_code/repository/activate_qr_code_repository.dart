import '../../../../api_models/api_response.dart';
import '../model/activate_qr_code_model.dart';

abstract class ActivateQRCodeRepository {
  Future<ApiResponse<ActivateQRCodeModel>> ActivateQRCode(dynamic data);
}
