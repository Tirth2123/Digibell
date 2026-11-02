

import '../../../../api_models/api_response.dart';
import '../model/GetAddressModel.dart';

abstract class GetAddressRepository {
  Future<ApiResponse<GetAllAddressModel>> get();
}