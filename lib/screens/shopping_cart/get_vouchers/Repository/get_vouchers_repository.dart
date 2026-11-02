import '../../../../api_models/api_response.dart';
import '../model/get_vouchers_model.dart';

abstract class GetVouchersRepository {
  Future<ApiResponse<GetVouchersModel>> get();
}
