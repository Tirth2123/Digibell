import '../../../../api_models/api_response.dart';
import '../model/contact_us_model.dart';

abstract class ContactUsRepository {
  Future<ApiResponse<ContactUsModel>> ContactUs(dynamic data);
}
