import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../api_models/api_response.dart';
import '../../../../api_models/api_status.dart';
import 'verify_otp_repository.dart';

class VerifyMobileOTPRepositoryImpl extends VerifyMobileOTPRepository {
  String? _verificationId;

  @override
  Future<ApiResponse> verifyOTP(String verificationId, String otp) async {
    try {
      print("Verify verification code - ${verificationId} ");
      if (verificationId.isEmpty == true) {
        return ApiResponse.error(errorMsg: 'Verification ID is null or empty.');
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return ApiResponse.success(status: ApiStatus.success, data: 'Verification successful');
    } on FirebaseException catch (e) {
      return ApiResponse.error(status: ApiStatus.error, errorMsg: e.message);
    }
  }
}