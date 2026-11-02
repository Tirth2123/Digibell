import '../../../../../api_models/api_response.dart';
import '../model/update_address_model.dart';

abstract class UpdateAddressRepository {
  Future<ApiResponse<UpdateAddressModel>> updateAddress(dynamic data, dynamic id);
}
