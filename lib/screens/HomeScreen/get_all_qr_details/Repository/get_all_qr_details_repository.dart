import '../../../../api_models/api_response.dart';
import '../model/get_all_qr_details_model.dart';

abstract class GetAllQRDetailsRepository {
  Future<ApiResponse<GetAllQRDetailsModel>> get();
}
