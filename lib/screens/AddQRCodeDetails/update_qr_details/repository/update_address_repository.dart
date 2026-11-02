import '../../../../api_models/api_response.dart';
import '../../add_qr_details/model/add_qr_details_model.dart';
import '../model/update_qr_details_model.dart';

abstract class UpdateQRDetailsRepository {
  Future<ApiResponse<UpdateQRDetailsModel>> UpdateQRDetails(dynamic data, dynamic id);
}
