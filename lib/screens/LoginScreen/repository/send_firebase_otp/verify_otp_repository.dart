import '../../../../api_models/api_response.dart';

abstract class VerifyMobileOTPRepository {
  Future<ApiResponse> verifyOTP(String verificationId, String otp);
}
