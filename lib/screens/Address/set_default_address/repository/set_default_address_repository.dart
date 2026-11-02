import '../../../../api_models/api_response.dart';
import '../model/set_default_address_model.dart';

abstract class SetDefaultAddressRepository {
  Future<ApiResponse<SetDefaultAddressModel>> SetDefaultAddress(  dynamic id);
}
