
import 'package:Digibells/api_models/api_response.dart';
import 'package:Digibells/screens/LoginScreen/model/send_otp.dart';

abstract class SendOtpRepository {
  Future<ApiResponse<SendOtp>> sendOtp(dynamic data);
}