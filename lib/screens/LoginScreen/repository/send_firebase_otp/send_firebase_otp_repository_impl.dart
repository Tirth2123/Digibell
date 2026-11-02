// import 'dart:async';
//
// import 'package:digibells_app/screens/LoginScreen/repository/send_firebase_otp_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../../../api_models/api_response.dart';
// import '../../../utils/alert_utils.dart';
//
// class SendMobileOTPRepositoryImpl extends SendMobileOTPRepository {
//   @override
//   Future<ApiResponse> sendOTP(phoneNumber) async {
//     Completer<ApiResponse> completer = Completer<ApiResponse>();
//     try {
//       print('OTP BLOC 1 ${phoneNumber}');
//       String verificationId = '';
//       await FirebaseAuth.instance.signOut();
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: '$phoneNumber',
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential authCredential) {
//
//         },
//         codeAutoRetrievalTimeout: (String verId) {
//
//         },
//         verificationFailed: (FirebaseAuthException error) {
//           print('OTP BLOC 2 ${error.message}');
//           AlertUtils.showToast('Please check your phone number and try again');
//           print('OTP BLOC 5 ${verificationId}');
//           return completer.complete(ApiResponse.error(errorMsg: error.message));
//         },
//         codeSent: (String Id, int? forceResendingToken) async {
//           verificationId = Id;
//           print('OTP BLOC 5 ${verificationId}');
//           return completer.complete(ApiResponse.success(data: verificationId));
//         },
//       );
//       return completer.future;
//     } on FirebaseException catch (error) {
//       print("Error ${error.toString()}");
//       return ApiResponse.error(errorMsg: error.toString());
//     }
//   }
//
//   @override
//   Future<ApiResponse> verifyOTP(verificationid, otp) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationid, smsCode: otp);
//       print('CREDENTIALS ${credential.token} ${verificationid} ${otp}');
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       return ApiResponse.success(data: 'Verification successful');
//     } on FirebaseException catch (e) {
//       return ApiResponse.error(errorMsg: e.toString());
//     }
//   }
// }
import 'dart:async';
import 'package:Digibells/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../api_models/api_response.dart';
import '../../../../api_models/api_status.dart';
import '../../../../utils/alert_utils.dart';
import '../../../../utils/stream_builder.dart';
import 'send_firebase_otp_repository.dart';

class SendMobileOTPRepositoryImpl extends SendMobileOTPRepository {
  String? _verificationId;

  @override
  Future<ApiResponse> sendOTP(String phoneNumber) async {
    Completer<ApiResponse> completer = Completer<ApiResponse>();
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential authCredential) {
          logger.w("VERIFICATION COMPLETED.");
          // Automatically handle the OTP
        },
        codeAutoRetrievalTimeout: (String verId) {
          _verificationId = verId;
        },
        verificationFailed: (FirebaseAuthException error) {
          logger.e("FIREBASE OTP VERIFICATION FAILED.");
          // AlertUtils.showToast('Please check your phone number and try again');
          return completer.complete(ApiResponse.error(errorMsg: error.message));
        },
        codeSent: (String verId, int? forceResendingToken) {
          StreamUtil.verificationIDSubject.add(verId);
          logger.w("VERIFICATION CODE SEND SUCCESSFULLY.");
          _verificationId = verId;
          return completer.complete(ApiResponse.success(status: ApiStatus.success, data: verId));
        },
      );
      return completer.future;
    } on FirebaseException catch (error) {
      return ApiResponse.error(status: ApiStatus.error, errorMsg: error.message);
    }
  }
}
