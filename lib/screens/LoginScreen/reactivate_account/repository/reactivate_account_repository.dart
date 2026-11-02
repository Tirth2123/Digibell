import '../../../../api_models/api_response.dart';
import '../model/reactivate_account_model.dart';

abstract class ReactivateAccountRepository {
  Future<ApiResponse<ReactivateAccountModel>> ReactivateAccount(dynamic data);
}
