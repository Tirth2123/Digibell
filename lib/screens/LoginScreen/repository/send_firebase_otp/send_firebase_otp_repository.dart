import '../../../../api_models/api_response.dart';

abstract class SendMobileOTPRepository {
  Future<ApiResponse> sendOTP(String phoneNumber);
  // Future<ApiResponse> verifyOTP(String verificationId, String otp);
}
