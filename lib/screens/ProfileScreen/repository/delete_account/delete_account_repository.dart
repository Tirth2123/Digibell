import '../../../../api_models/api_response.dart';
import '../../model/delete_account_model.dart';


abstract class DeleteAccountRepository {
  Future<ApiResponse<DeleteAccountModel>> deleteAccount();
}



