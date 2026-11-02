import 'dart:convert';
import 'package:Digibells/screens/LoginScreen/bloc/guest_user/guest_user_bloc.dart';
import 'package:Digibells/screens/LoginScreen/bloc/guest_user/guest_user_event.dart';
import 'package:Digibells/screens/LoginScreen/reactivate_account/bloc/reactivate_account_bloc.dart';
import 'package:Digibells/screens/LoginScreen/reactivate_account/bloc/reactivate_account_event.dart';
import 'package:Digibells/screens/LoginScreen/reactivate_account/bloc/reactivate_account_state.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../constants/asset_path.dart';
import '../../constants/common_regExps.dart';
import '../../firebase_notification/deviceModel.dart';
import '../../firebase_notification/notification_service.dart';
import '../../main.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_textfield.dart';
import '../../utils/logger.dart';
import '../../utils/stream_builder.dart';
import '../SingUP/bloc/register_bloc.dart';
import 'bloc/data_check/bloc/data_check_bloc.dart';
import 'bloc/guest_user/guest_user_state.dart';
import 'bloc/login/bloc/login_screen_bloc.dart';
import 'bloc/send_firebase_otp/bloc/send_firebase_otp_bloc.dart';
import 'bloc/send_firebase_otp/bloc/verify_otp_bloc.dart';
import 'bloc/send_otp/send_otp_bloc.dart';
import 'bloc/social_login/bloc/social_login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => LoginBloc()),
        BlocProvider<GuestUserBloc>(create: (_) => GuestUserBloc()),
        BlocProvider(
          create: (context) => SendOtpBloc(),
        ),
        BlocProvider(
          create: (context) => DataCheckBloc(),
        ),
        BlocProvider(
          create: (context) => SocialLoginBloc(),
        ),
        BlocProvider<ReactivateAccountBloc>(create: (_) => ReactivateAccountBloc()),
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => VerifyOtpBloc(),
        ),
      ],
      child: LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController contactNumberController = TextEditingController();
  FocusNode contactNumberFocusNode = FocusNode();
  bool contactNumberValidate = false;
  bool emptyContactNumberValidate = false;
  bool contactNumberPatternValidate = false;

  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();
  bool otpValidate = false;
  bool emptyotpValidate = false;

  BehaviorSubject<bool> isSendOTP = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> isVerifyDone = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<String> verificationId = BehaviorSubject<String>.seeded('');

  auth.User? user;
  late final firebaseUser;

  String deviceData = '';
  DeviceDetails? deviceDetails;

  @override
  void dispose() {
    isSendOTP.close();
    verificationId.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      body: BlocConsumer<GuestUserBloc, GuestUserState>(
        listener: (context, guestState) {
          if (guestState.isCompleted) {
            prefs?.setBool(AppConstants.guestLogin, true) ?? false;
            prefs?.setBool(AppConstants.allowNotification, guestState.guestUserModel?.data?.allowNotification ?? false) ?? false;
            prefs?.setString(AppConstants.token, guestState.guestUserModel?.token ?? "");
            prefs?.setString(AppConstants.userName, guestState.guestUserModel?.data?.name ?? "");
            prefs?.setString(AppConstants.userContact, guestState.guestUserModel?.data?.mobileNumber ?? "");
            prefs?.setString(AppConstants.userId, guestState.guestUserModel?.data?.sId ?? '');
            Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
            StreamUtil.bottomNavigationIndex.add(0);
          } else if (guestState.isFailed) {
            AlertUtils.showManuallyCloseDialogue(context, guestState.errorMsg ?? '', 4, 'Oops!');
            otpController.clear();
          }
        },
        builder: (context, guestState) {
          return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
            listener: (context, stateV) {
              if (stateV.isCompleted) {
                isSendOTP.add(true);
                checkData(contactNumberController.text.trim());
                // AlertUtils.showToast('OTP verified successfully');
              } else if (stateV.isFailed) {
                AlertUtils.showToast('Please enter valid OTP.');
              }
            },
            builder: (context, stateV) {
              return BlocConsumer<SendOtpBloc, SendOtpState>(
                listener: (context, stateOTP) {
                  /*if (stateOTP.isCompleted) {
                    if (stateOTP.otpSent == true) {
                      isSendOTP.add(false);
                      AlertUtils.showToast('OTP successfully sent to phone number.');
                    } else if (stateOTP.verified == true) {}
                  }*/

                  if (stateOTP.isCompleted) {
                    isSendOTP.add(false);
                    AlertUtils.showToast('OTP successfully sent to phone number.');
                  }
                },
                builder: (context, stateOTP) {
                  return BlocConsumer<DataCheckBloc, DataCheckState>(
                    listener: (context, stateC) async {
                      if (stateC.isCompleted) {
                        if (stateC.model?.data?.deleted == true) {
                          _showReactivateAccountDialog(context);
                        } else {
                          if (prefs?.getString(AppConstants.deviceData) == null) {
                            await PushNotificationService().getDeviceData();
                          }
                          String deviceData = prefs?.getString(AppConstants.deviceData) ?? '';
                          if (deviceData.isNotEmpty) {
                            try {
                              Map<String, dynamic> deviceMap = jsonDecode(deviceData);
                              String deviceId = (deviceMap['deviceId'] ?? '').trim();
                              String fcmToken = (deviceMap['fcmToken'] ?? '').trim();
                              String voipToken = (deviceMap['voipToken'] ?? '').trim();
                              String deviceCompany = (deviceMap['deviceCompany'] ?? '').trim();
                              String deviceName = (deviceMap['deviceName'] ?? '').trim();
                              String os = (deviceMap['os'] ?? '').trim();
                              String appVersion = (deviceMap['appVersion'] ?? '').trim();
                              String osVersion = (deviceMap['osVersion'] ?? '').trim();
                              // Parse mobile number once
                              int? mobileNumber = int.tryParse(contactNumberController.text);
                              if (mobileNumber != null) {
                                // Check if the user is a New User
                                if (stateC.model?.message == "New User") {
                                  var body = {
                                    "mobileNumber": mobileNumber,
                                    "device_id": deviceId,
                                    "fcm_token": fcmToken,
                                    "voip_token": voipToken,
                                    "device_company": deviceCompany,
                                    "device_name": deviceName,
                                    "os": os,
                                    "app_version": appVersion,
                                    "os_version": osVersion,
                                    "otp": otpController.text,
                                  };
                                  // Trigger the Register event
                                  BlocProvider.of<RegisterBloc>(context).add(
                                    PerformRegisterEvent(data: body),
                                  );
                                } else {
                                  var body = {
                                    "mobileNumber": mobileNumber, // No need to parse again
                                    "device_id": deviceId,
                                    "fcm_token": fcmToken,
                                    "voip_token": voipToken,
                                    "device_company": deviceCompany,
                                    "device_name": deviceName,
                                    "os": os,
                                    "app_version": appVersion,
                                    "os_version": osVersion,
                                    "otp": otpController.text,
                                  };
                                  // Trigger the Login event
                                  BlocProvider.of<LoginBloc>(context).add(
                                    PerformLoginEvent(data: body),
                                  );
                                }
                              } else {
                                logger.e('Invalid mobile number');
                              }
                            } catch (e) {
                              logger.e('Error decoding device data: $e');
                            }
                          } else {
                            logger.e('No device data found');
                          }
                        }
                      }
                    },
                    builder: (context, stateC) {
                      return BlocConsumer<RegisterBloc, RegisterState>(
                        listener: (context, state) async {
                          if (state.isCompleted) {
                            AlertUtils.showToast('OTP verified successfully');
                            prefs?.setBool(AppConstants.register, true) ?? false;
                            prefs?.setString(AppConstants.token, state.registerModel?.token ?? "");
                            Navigator.pushNamedAndRemoveUntil(context, AppScreens.singUpScreen, (Route<dynamic> route) => false);
                          } else if (state.isFailed) {
                            AlertUtils.showManuallyCloseDialogue(context, state.errorMsg!, 4, 'Oops!');
                          }
                        },
                        builder: (context, state) {
                          return BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, stateL) async {
                              if (stateL.isCompleted) {
                                prefs?.setBool(AppConstants.login, true) ?? false;
                                prefs?.setBool(AppConstants.allowNotification, stateL.loginModel?.data?.allowNotification ?? false) ?? false;
                                prefs?.setString(AppConstants.token, stateL.loginModel?.token ?? "");
                                prefs?.setString(AppConstants.userName, stateL.loginModel?.data?.name ?? "");
                                prefs?.setString(AppConstants.userEmail, stateL.loginModel?.data?.email ?? "");
                                prefs?.setString(AppConstants.userContact, stateL.loginModel?.data?.mobileNumber ?? "");
                                prefs?.setString(AppConstants.profilePicture, stateL.loginModel?.data?.userImage ?? "");
                                prefs?.setString(AppConstants.userDOB, stateL.loginModel?.data?.dob ?? '');
                                prefs?.setString(AppConstants.userId, stateL.loginModel?.data?.sId ?? '');
                                Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
                                StreamUtil.bottomNavigationIndex.add(0);
                                AlertUtils.showToast('OTP verified successfully');
                              } else if (stateL.isFailed) {
                                AlertUtils.showManuallyCloseDialogue(context, stateL.errorMsg ?? '', 4, 'Oops!');
                                otpController.clear();
                              }
                            },
                            builder: (context, stateL) {
                              return Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                      color: AppStyles.primary,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 150.h,
                                            color: AppStyles.primary,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Enter Your Phone",
                                                    style: AppStyles.white_24_w400,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text("Number", style: AppStyles.white_24_w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 40.h, left: 40.w, right: 40.w, bottom: 20.h),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    ImageAssetPath.loginScreen,
                                                  ),
                                                  SizedBox(height: 50.h),
                                                  CustomTextField(
                                                    readOnly: isSendOTP.value == true ? false : true,
                                                    autoFocus: false,
                                                    focusNode: contactNumberFocusNode,
                                                    textCapitalize: TextCapitalization.words,
                                                    errorMessage: contactNumberValidate == true
                                                        ? emptyContactNumberValidate == true
                                                            ? CommonMessage.enterMobile
                                                            : contactNumberPatternValidate == true
                                                                ? CommonMessage.enterValidMobile
                                                                : "null"
                                                        : "null",
                                                    isValidate: contactNumberValidate,
                                                    onChange: (data) {
                                                      if (data.toString().isEmpty) {
                                                        setState(() {
                                                          contactNumberValidate = true;
                                                          emptyContactNumberValidate = true;
                                                        });
                                                      } else {
                                                        if (CommonRegExps.mobileRegExp.hasMatch(
                                                          data,
                                                        )) {
                                                          setState(() {
                                                            contactNumberValidate = false;
                                                            emptyContactNumberValidate = false;
                                                            contactNumberPatternValidate = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            contactNumberValidate = true;
                                                            emptyContactNumberValidate = false;
                                                            contactNumberPatternValidate = true;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    inputFormatter: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                      LengthLimitingTextInputFormatter(10),
                                                    ],
                                                    hintText: "Enter Mobile Number",
                                                    textFieldController: contactNumberController,
                                                    isPasswordField: false,
                                                    keyboardType: TextInputType.number,
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  CustomTextField(
                                                    readOnly: isSendOTP.value == false ? false : true,
                                                    autoFocus: false,
                                                    focusNode: otpFocusNode,
                                                    errorMessage: otpValidate == true ? CommonMessage.enterOtp : '',
                                                    isValidate: otpValidate,
                                                    onChange: (data) {
                                                      if (data.toString().isEmpty) {
                                                        setState(() {
                                                          otpValidate = true;
                                                          emptyotpValidate = true;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          otpValidate = true;
                                                          emptyotpValidate = false;
                                                        });
                                                      }
                                                    },
                                                    inputFormatter: [
                                                      FilteringTextInputFormatter.digitsOnly,
                                                      LengthLimitingTextInputFormatter(6),
                                                    ],
                                                    hintText: "Enter OTP",
                                                    isPasswordField: false,
                                                    textFieldController: otpController,
                                                    keyboardType: TextInputType.number,
                                                  ),
                                                  SizedBox(
                                                    height: 14.h,
                                                  ),
                                                  StreamBuilder<bool>(
                                                      stream: isSendOTP,
                                                      builder: (context, sendSnapshot) {
                                                        return Column(
                                                          children: [
                                                            Visibility(visible: sendSnapshot.data == true, child: buildSendButton()),
                                                            Visibility(
                                                                visible: sendSnapshot.data == false,
                                                                child: buildVerifyButton(otpController.text.trim())),
                                                          ],
                                                        );
                                                      }),
                                                  SizedBox(
                                                    height: 16.h,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await guestUser();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                              text: 'Continue without login?',
                                                              style: TextStyle(color: AppStyles.black, fontSize: 16),
                                                              children: <TextSpan>[
                                                                TextSpan(
                                                                    text: ' Guest',
                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppStyles.primary)),
                                                              ]),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    child: LoaderWidget(),
                                    visible: stateV.isLoading || stateOTP.isLoading || stateL.isLoading || guestState.isLoading,
                                  )
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future socialLoginAPI(String type, auth.User user) async {
    String? token = await user.getIdToken(true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceData = pref.getString(AppConstants.deviceData) ?? '';
    Map<String, dynamic> deviceMap = jsonDecode(deviceData) as Map<String, dynamic>;
    DeviceDetails deviceDetails = DeviceDetails.fromJson(deviceMap);
    var data = {
      "socialType": 'G',
      "firebaseToken": token!,
      "deviceId": deviceDetails.deviceId,
      "fcmToken": deviceDetails.fcmToken,
      "voipToken": deviceDetails.voipToken ?? '',
      "deviceCompany": deviceDetails.deviceCompany,
      "deviceName": deviceDetails.deviceName,
      "os": deviceDetails.os,
      "appVersion": deviceDetails.appVersion,
      "osVersion": deviceDetails.osVersion
    };
    BlocProvider.of<SocialLoginBloc>(context).add(
      PerformSocialLoginEvent(data: data),
    );
  }

  Future checkData(dynamic phone) async {
    BlocProvider.of<DataCheckBloc>(context).add(
      PerformDataCheckEvent(data: phone),
    );
  }

  Future guestUser() async {
    BlocProvider.of<GuestUserBloc>(context).add(
      PerformGuestUserEvent(),
    );
  }

  Future socialLogin(String type, String token) async {
    Map bodyData = {'socialLoginType': type, 'socialLoginToken': token};
    BlocProvider.of<LoginBloc>(context).add(PerformLoginEvent(data: bodyData));
  }

  Widget buildSendButton() {
    return SizedBox(
      width: 300.w,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          if (contactNumberController.text.trim().isEmpty) {
            AlertUtils.showToast("Phone number should not be empty.");
          } else if (RegExp(r'^(.)\1*$').hasMatch(contactNumberController.text)) {
            AlertUtils.showToast('Please enter valid phone number');
          } else {
            /*BlocProvider.of<SendFirebaseOtpBloc>(context).add(
              PerformSendFirebaseOtpEvent(phoneNumber: '+91${contactNumberController.text.trim()}'),
            );*/

            Map body = {
              'mobileNumber': '${contactNumberController.text.trim()}'
            };

            BlocProvider.of<SendOtpBloc>(context).add(
              PerformSendOtpEvent(data: body),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Send OTP',
          style: AppStyles.white_16_w700,
        ),
      ),
    );
  }

  Widget buildVerifyButton(String otp) {
    return SizedBox(
      width: 300.w,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          if (otp.isNotEmpty) {
            /*if (StreamUtil.verificationIDSubject.hasValue) {
              BlocProvider.of<VerifyOtpBloc>(context).add(
                PerformVerifyOtpEvent(verificationId: StreamUtil.verificationIDSubject.value, otp: otp),
              );
            }*/

            isSendOTP.add(true);
            checkData(contactNumberController.text.trim());
          } else {
            AlertUtils.showToast("OTP should not be empty.");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Verify OTP',
          style: AppStyles.white_16_w700,
        ),
      ),
    );
  }

  void _showReactivateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reactivate Account?', style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500)),
          content: Text('Your account has been deleted, you want to reactivate it?',
              style: AppStyles.greyColor_12_w500.copyWith(
                fontSize: 14.sp,
              )),
          actions: [
            TextButton(
              child: Text('No',
                  style: AppStyles.white_15_w500.copyWith(
                    color: AppStyles.primary,
                  )),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushNamedAndRemoveUntil(context, AppScreens.loginScreen, (Route<dynamic> route) => false);
              },
            ),
            BlocConsumer<ReactivateAccountBloc, ReactivateAccountState>(
              listener: (context, state) {
                if (state.isCompleted) {
                  checkData(contactNumberController.text.trim());
                  AlertUtils.showToast("Account reactivated successfully.");
                }
              },
              builder: (context, state) {
                return state.isLoading
                    ? SizedBox(
                        height: 25.h,
                        width: 25.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          color: AppStyles.primary,
                        ),
                      )
                    : TextButton(
                        child: Text('Yes',
                            style: AppStyles.white_15_w500.copyWith(
                              color: AppStyles.primary,
                            )),
                        onPressed: () async {
                          await reactivateAccount();
                        });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> reactivateAccount() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "mobileNumber": contactNumberController.text.trim(),
      };
      BlocProvider.of<ReactivateAccountBloc>(context).add(
        PerformReactivateAccountEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
