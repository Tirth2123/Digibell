import '../../../../api_models/api_response.dart';
import '../model/help_faqs_model.dart';

abstract class HelpFaqsRepository {
  Future<ApiResponse<HelpFaqsModel>> get();
}
