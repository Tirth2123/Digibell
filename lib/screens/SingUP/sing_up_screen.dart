import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../constants/common_regExps.dart';
import '../../firebase_notification/deviceModel.dart';
import '../../main.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/custom_textfield.dart';
import '../LoginScreen/login_screen.dart';
import 'bloc/user_details_bloc.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({
    super.key,
  });

  static Widget create() {
    return MultiBlocProvider(
      providers: [BlocProvider<UserDetailsBloc>(create: (_) => UserDetailsBloc())],
      child: SingUpScreen(),
    );
  }

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  TextEditingController emailAddressController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  TextEditingController referralCodeController = TextEditingController();

  TextEditingController contactNumberController = TextEditingController();
  FocusNode contactNumberFocusNode = FocusNode();

  TextEditingController addressController = TextEditingController();
  FocusNode addressFocusNode = FocusNode();

  TextEditingController dobController = TextEditingController();
  FocusNode dobFocusNode = FocusNode();

  DateTime currentDate = DateTime.now();

  String deviceData = '';
  DeviceDetails? deviceDetails;
  LoginScreen? numberDetails;

  Logger logger = Logger();

  @override
  void initState() {
    // initValue();
    super.initState();
  }

  // Future initValue() async {
  //   prefs = await SharedPreferences.getInstance();
  //   // fcmToken = prefs?.getString(AppConstants.FCMTOKEN) ?? '';
  //
  //   deviceData = prefs!.getString(AppConstants.deviceData) ?? '';
  //   Map<String, dynamic> deviceMap =
  //       jsonDecode(deviceData) as Map<String, dynamic>;
  //   deviceDetails = DeviceDetails.fromJson(deviceMap);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primary,
      body: SafeArea(
        child: BlocConsumer<UserDetailsBloc, UserDetailsState>(
          listener: (context, state) async {
            if (state.isCompleted) {
              prefs?.setBool(AppConstants.login, true) ?? false;
              prefs?.setString(AppConstants.userName, state.userDetailsModel?.data?.name ?? "");
              prefs?.setString(AppConstants.userEmail, state.userDetailsModel?.data?.email ?? "");
              prefs?.setBool(AppConstants.allowNotification, state.userDetailsModel?.data?.allowNotification ?? false);
              prefs?.setString(AppConstants.userContact, state.userDetailsModel?.data?.mobileNumber ?? "");
              prefs?.setString(AppConstants.userDOB, state.userDetailsModel?.data?.dob ?? '');
              prefs?.setString(AppConstants.profilePicture, state.userDetailsModel?.data?.userImage ?? "");
              prefs?.setString(AppConstants.userId, state.userDetailsModel?.data?.id ?? "");
              Navigator.pushNamedAndRemoveUntil(context, AppScreens.firstTimeHomeScreen, (Route<dynamic> route) => false);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
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
                            "Enter Your Details",
                            style: AppStyles.white_24_w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 750.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.h, left: 40.w, right: 40.w),
                      child: Column(
                        children: [
                          CustomTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                            ],
                            autoFocus: false,
                            focusNode: nameFocusNode,
                            textCapitalize: TextCapitalization.words,
                            hintText: "Enter Name",
                            isPasswordField: false,
                            textFieldController: nameController,
                            keyboardType: TextInputType.name,
                          ),
                          CustomTextField(
                            textCapitalize: TextCapitalization.none,
                            textFieldController: emailAddressController,
                            focusNode: emailFocusNode,
                            hintText: "Enter Email Id",
                            isPasswordField: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          CustomTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                            ],
                            autoFocus: false,
                            focusNode: addressFocusNode,
                            textCapitalize: TextCapitalization.words,
                            hintText: "Enter Address",
                            isPasswordField: false,
                            textFieldController: addressController,
                            keyboardType: TextInputType.name,
                          ),
                          CustomTextField(
                            calendarToday: true,
                            focusNode: dobFocusNode,
                            readOnly: true,
                            hintText: "Enter DOB",
                            isPasswordField: false,
                            keyboardType: TextInputType.none,
                            textFieldController: dobController,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                builder: (context, child) => Theme(
                                  data: ThemeData().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: AppStyles.primary,
                                      onPrimary: Colors.white,
                                      surface: AppStyles.secondaryPrimaryColor,
                                      onSurface: Colors.black,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppStyles.primary,
                                      ),
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child ?? Container(),
                                ),
                                context: context,
                                initialDate: currentDate,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

                                dobController.text = formattedDate;
                              }
                            },
                          ),
                          CustomTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                            ],
                            maxLength: 8,
                            autoFocus: false,
                            textCapitalize: TextCapitalization.words,
                            hintText: "Enter Referral Code",
                            isPasswordField: false,
                            textFieldController: referralCodeController,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: 300.w,
                            height: 55.h,
                            child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (nameController.text.isEmpty) {
                                  AlertUtils.showToast("Name should not be empty.");
                                  //FocusScope.of(context).requestFocus(nameFocusNode);
                                } else if (!_isValidName(nameController.text)) {
                                  AlertUtils.showToast("Enter a valid name");
                                  //FocusScope.of(context).requestFocus(nameFocusNode);
                                } else if (emailAddressController.text.isEmpty) {
                                  AlertUtils.showToast("Email should not be empty.");
                                  //FocusScope.of(context).requestFocus(emailFocusNode);
                                } else if (!_isValidEmail(emailAddressController.text)) {
                                  AlertUtils.showToast("Enter a valid email address");
                                  //FocusScope.of(context).requestFocus(emailFocusNode);
                                } else if (addressController.text.isEmpty) {
                                  AlertUtils.showToast("Address should not be empty.");
                                  // FocusScope.of(context).requestFocus(addressFocusNode);
                                } else if (!_isValidAddress(addressController.text)) {
                                  AlertUtils.showToast("Enter a valid address");
                                  // FocusScope.of(context).requestFocus(addressFocusNode);
                                } else if (dobController.text.isEmpty) {
                                  AlertUtils.showToast("Date of birth should not be empty.");
                                  // FocusScope.of(context).requestFocus(dobFocusNode);
                                } else {
                                  userDetailsSubmitButton();
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
                                'Submit',
                                style: AppStyles.white_16_w700,
                              ),
                            ),
                          ),
                          // SizedBox(height: 150.h),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     SvgPicture.asset(ImageAssetPath.infoSvg),
                          //     SizedBox(
                          //       width: 15.w,
                          //     ),
                          //     SizedBox(
                          //       width: 250.w,
                          //       child: Text(
                          //           'Lorem ipsum dolor sit amet consectetur. Etiam urna viverra volutpat commodo dignissim purus quis laoreet praesent. ',
                          //           maxLines: 4,
                          //           overflow: TextOverflow.ellipsis,
                          //           // textAlign: TextAlign.center,
                          //           style: AppStyles.textFieldText_15_w500
                          //               .copyWith(color: AppStyles.normalText)),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    // color: AppStyles.white,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    final RegExp onlyNumbersRegex = RegExp(r'^[0-9]+$');
    if (!emailRegex.hasMatch(email)) {
      return false;
    }
    final String username = email.split('@').first;
    if (onlyNumbersRegex.hasMatch(username)) {
      return false;
    }

    return true;

    // final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    // final RegExp onlyNumbersRegex = RegExp(r'^[0-9]+$');
    // return emailRegex.hasMatch(email) && !onlyNumbersRegex.hasMatch(email);
  }

  bool _isValidName(String name) {
    final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z\s]+$'); // Only letters and spaces.
    return validCharactersRegex.hasMatch(name);
  }

  bool _isValidAddress(String address) {
    final RegExp addressRegex = RegExp("[a-zA-Z\w+( )\w+]");
    final RegExp onlyNumbersRegex = RegExp(r'^[0-9]+$');
    return addressRegex.hasMatch(address) && !onlyNumbersRegex.hasMatch(address);
  }

  void userDetailsSubmitButton() {
    var body = referralCodeController.text.trim() != ""
        ? {
            "name": nameController.text.trim(),
            "email": emailAddressController.text.trim(),
            "dob": dobController.text.trim(),
            "address": addressController.text.trim(),
            "referralCode": referralCodeController.text.trim()
          }
        : {
            "name": nameController.text.trim(),
            "email": emailAddressController.text.trim(),
            "dob": dobController.text.trim(),
            "address": addressController.text.trim(),
          };
    BlocProvider.of<UserDetailsBloc>(context).add(
      PerformUserDetailsEvent(data: body),
    );
  }
}
