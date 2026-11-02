import '../../../../api_models/api_response.dart';
import '../model/add_qr_details_model.dart';

abstract class AddQRDetailsRepository {
  Future<ApiResponse<AddQRDetailsModel>> AddQRDetails(dynamic data);
}
