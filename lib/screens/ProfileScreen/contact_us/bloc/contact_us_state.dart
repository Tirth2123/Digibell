import '../../../../api_models/api_error.dart';
import '../model/contact_us_model.dart';

class ContactUsState {
  final bool isLoading;
  final ApiError? error;
  final String? errorMsg;
  final bool isCompleted;
  final bool isFailed;
  final ContactUsModel? contactUsModel;

  ContactUsState({this.isLoading = false, this.error, this.errorMsg = '', this.isCompleted = false, this.isFailed = false, this.contactUsModel});
}
