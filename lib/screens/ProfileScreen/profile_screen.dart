import 'dart:io';
import 'package:Digibells/screens/ProfileScreen/contact_us/bloc/contact_us_bloc.dart';
import 'package:Digibells/screens/ProfileScreen/contact_us/bloc/contact_us_event.dart';
import 'package:Digibells/screens/ProfileScreen/contact_us/bloc/contact_us_state.dart';
import 'package:Digibells/screens/ProfileScreen/logout/bloc/logout_event.dart';
import 'package:Digibells/screens/ProfileScreen/modify_notification/bloc/modify_notification_event.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/utils/stream_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_client/api_constans.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import 'package:dio/dio.dart' as D;
import '../../constants/asset_path.dart';
import '../../constants/common_regExps.dart';
import '../../helper/api_base_helper.dart';
import '../../main.dart';
import '../../soketIO/bloc/socket_connect_bloc.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_textfield.dart';
import 'bloc/delete_account/delete_account_bloc.dart';
import 'bloc/update_profile/update_profile_bloc.dart';
import 'bloc/upload_image/upload_image_bloc.dart';
import 'logout/bloc/logout_bloc.dart';
import 'logout/bloc/logout_state.dart';
import 'modify_notification/bloc/modify_notification_bloc.dart';
import 'modify_notification/bloc/modify_notification_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdateProfileBloc>(create: (_) => UpdateProfileBloc()),
        BlocProvider<LogoutBloc>(create: (_) => LogoutBloc()),
        BlocProvider<UploadImageBloc>(create: (_) => UploadImageBloc()),
        BlocProvider<ModifyNotificationBloc>(create: (_) => ModifyNotificationBloc()),
        BlocProvider<DeleteAccountBloc>(create: (_) => DeleteAccountBloc()),
        BlocProvider<ContactUsBloc>(create: (_) => ContactUsBloc()),
        BlocProvider<SocketConnectBloc>(create: (_) => SocketConnectBloc()),
      ],
      child: ProfileScreen(),
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSelect = false;
  DateTime? dob;
  DateTime currentDate = DateTime.now();

  static BehaviorSubject<int> progress = BehaviorSubject<int>.seeded(0);

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  bool nameValidate = false;
  bool emptynameValidate = false;

  TextEditingController emailAddressController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  bool emailPatternValidate = false;
  bool emailValidate = false;
  bool emptyEmailValidate = false;

  TextEditingController contactNumberController = TextEditingController();
  FocusNode contactNumberFocusNode = FocusNode();
  bool contactNumberValidate = false;
  bool emptyContactNumberValidate = false;
  bool contactNumberPatternValidate = false;

  bool emptyDateValidate = false;
  bool dateValidate = false;
  TextEditingController dateController = TextEditingController();
  FocusNode dateFocusNode = FocusNode();
  String apiImg = "";

  @override
  void initState() {
    nameController.text = prefs?.getString(AppConstants.userName) ?? '';
    emailAddressController.text = prefs?.getString(AppConstants.userEmail) ?? '';
    contactNumberController.text = prefs?.getString(AppConstants.userContact) ?? '';
    dateController.text = prefs?.getString(AppConstants.userDOB) ?? '';
    apiImg = prefs?.getString(AppConstants.profilePicture) ?? '';
    isSelect = prefs?.getBool(AppConstants.allowNotification) ?? false;
    super.initState();
  }

  BehaviorSubject<List<String>> imagesUrl = BehaviorSubject<List<String>>.seeded([]);

  @override
  void dispose() {
    imagesUrl.value.clear();
    super.dispose();
  }

  TextEditingController contactUsNameController = TextEditingController();
  FocusNode contactUsNameFocusNode = FocusNode();
  bool contactUsNameValidate = false;
  bool contactUsNameEmptyValidate = false;

  TextEditingController contactUsPhoneController = TextEditingController();
  FocusNode contactUsPhoneFocusNode = FocusNode();
  bool contactUsPhoneValidate = false;
  bool contactUsPhoneEmptyValidate = false;
  bool contactUsPhonePatternValidate = false;

  TextEditingController contactUsDescriptionController = TextEditingController();
  FocusNode contactUsDescriptionFocusNode = FocusNode();
  bool contactUsDescriptionValidate = false;
  bool contactUsEmptyDescriptionValidate = false;

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout', style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500)),
          content: Text('Are you sure you want to log out?',
              style: AppStyles.greyColor_12_w500.copyWith(
                fontSize: 14.sp,
              )),
          actions: [
            TextButton(
              child: Text('Cancel',
                  style: AppStyles.white_15_w500.copyWith(
                    color: AppStyles.primary,
                  )),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            BlocConsumer<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state.isCompleted) {
                  prefs?.clear();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppScreens.splashscreen,
                    (Route<dynamic> route) => false,
                  );
                  AlertUtils.showToast("Logout successfully.");
                }
              },
              builder: (context, state) {
                return TextButton(
                  child: Text('Logout',
                      style: AppStyles.white_15_w500.copyWith(
                        color: AppStyles.primary,
                      )),
                  onPressed: () async {
                    await logout();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete?', style: AppStyles.black_17_w600.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w500)),
          content: Text('Are you sure you want to delete this account?',
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
              },
            ),
            BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
              listener: (context, state) {
                if (state.isCompleted) {
                  prefs?.clear();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppScreens.splashscreen,
                    (Route<dynamic> route) => false,
                  );
                  AlertUtils.showToast("Delete account successfully.");
                }
              },
              builder: (context, state) {
                return TextButton(
                  child: Text('Delete',
                      style: AppStyles.white_15_w500.copyWith(
                        color: AppStyles.primary,
                      )),
                  onPressed: () async {
                    await deleteAccount();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<DeleteAccountBloc>(context).add(
        PerformDeleteAccountEvent(),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> logout() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

      String? deviceId;
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceId = '${build.id}';
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceId = '${data.identifierForVendor}';
      }
      var data = {
        "deviceId": deviceId ?? '',
      };
      StreamUtil.bottomNavigationIndex.add(0);
      BlocProvider.of<LogoutBloc>(context).add(
        PerformLogoutEvent(data: data),
      );
      BlocProvider.of<SocketConnectBloc>(context).add(
        PerformLogout(id: prefs?.getString(AppConstants.userId) ?? ''),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Widget contactUsBottomSheet(context) {
    return BlocConsumer<ContactUsBloc, ContactUsState>(
      listener: (context, contactState) {
        if (contactState.isCompleted) {
          contactUsDescriptionController.clear();
          contactUsPhoneController.clear();
          contactUsNameController.clear();
          Navigator.pop(context);
          AlertUtils.showToast("Message send successfully.");
        }
      },
      builder: (context, contactState) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: AppStyles.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h, left: 25.w, right: 25.w, bottom: 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name", style: AppStyles.textFieldText_15_w500),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        autoFocus: false,
                        focusNode: contactUsNameFocusNode,
                        textCapitalize: TextCapitalization.words,
                        errorMessage: contactUsNameValidate == true ? CommonMessage.enterName : '',
                        isValidate: contactUsNameValidate,
                        onChange: (data) {
                          if (data.toString().isEmpty) {
                            setState(() {
                              contactUsNameValidate = true;
                              contactUsNameEmptyValidate = true;
                            });
                          } else {}
                        },
                        hintText: "Enter Your Name",
                        isPasswordField: false,
                        textFieldController: contactUsNameController,
                        keyboardType: TextInputType.name,
                      ),
                      Text("Phone Number", style: AppStyles.textFieldText_15_w500),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        autoFocus: false,
                        focusNode: contactUsPhoneFocusNode,
                        textCapitalize: TextCapitalization.words,
                        errorMessage: contactUsPhoneValidate == true
                            ? contactUsPhoneEmptyValidate == true
                                ? CommonMessage.enterMobile
                                : contactUsPhonePatternValidate == true
                                    ? CommonMessage.enterValidMobile
                                    : "null"
                            : "null",
                        isValidate: contactUsPhoneValidate,
                        onChange: (data) {
                          if (data.toString().isEmpty) {
                            setState(() {
                              contactUsPhoneValidate = true;
                              contactUsPhoneEmptyValidate = true;
                            });
                          } else {
                            if (CommonRegExps.mobileRegExp.hasMatch(
                              data,
                            )) {
                              setState(() {
                                contactUsPhoneValidate = false;
                                contactUsPhoneEmptyValidate = false;
                                contactUsPhonePatternValidate = false;
                              });
                            } else {
                              setState(() {
                                contactUsPhoneValidate = true;
                                contactUsPhoneEmptyValidate = false;
                                contactUsPhonePatternValidate = true;
                              });
                            }
                          }
                        },
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        hintText: "Enter Phone Number",
                        isPasswordField: false,
                        textFieldController: contactUsPhoneController,
                        keyboardType: TextInputType.number,
                      ),
                      Text("Message", style: AppStyles.textFieldText_15_w500),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomTextField(
                        isLargeTextField: true,
                        autoFocus: false,
                        focusNode: contactUsDescriptionFocusNode,
                        textCapitalize: TextCapitalization.sentences,
                        errorMessage: contactUsDescriptionValidate == true ? CommonMessage.enterMessage : '',
                        isValidate: contactUsDescriptionValidate,
                        onChange: (data) {
                          if (data.toString().isEmpty) {
                            setState(() {
                              contactUsDescriptionValidate = true;
                              contactUsEmptyDescriptionValidate = true;
                            });
                          } else {}
                        },
                        hintText: "Write message...",
                        isPasswordField: false,
                        textFieldController: contactUsDescriptionController,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: contactState.isLoading
                            ? SizedBox(
                                height: 35.h,
                                width: 35.w,
                                child: CircularProgressIndicator(
                                  color: AppStyles.primary,
                                ))
                            : SizedBox(
                                width: 400.w,
                                height: 55.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (contactUsNameController.text.isEmpty) {
                                      AlertUtils.showToast("Name should not be empty.");
                                      // FocusScope.of(context).requestFocus(contactUsNameFocusNode);
                                    } else if (!_isValidName(contactUsNameController.text)) {
                                      AlertUtils.showToast("Please enter a valid name");
                                    } else if (contactUsPhoneController.text.isEmpty) {
                                      AlertUtils.showToast("Phone number should not be empty.");
                                      // FocusScope.of(context).requestFocus(contactUsPhoneFocusNode);
                                    } else if (!_isValidPhone(contactUsPhoneController.text)) {
                                      AlertUtils.showToast("Please enter a valid phone number");
                                    } else if (contactUsDescriptionController.text.isEmpty) {
                                      AlertUtils.showToast("Message should not be empty.");
                                      // FocusScope.of(context).requestFocus(contactUsDescriptionFocusNode);
                                    } else {
                                      contactUs();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.primary,
                                    padding: EdgeInsets.symmetric(vertical: 16.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text('Contact Us', style: AppStyles.white_16_w700),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget personalInformationBottomSheet(context) {
    return Container(
      // padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppStyles.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SizedBox(
        // width: 92.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.h, left: 25.w, right: 25.w, bottom: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name", style: AppStyles.textFieldText_15_w500),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextField(
                    autoFocus: false,
                    focusNode: nameFocusNode,
                    textCapitalize: TextCapitalization.words,
                    errorMessage: nameValidate == true ? CommonMessage.enterName : '',
                    isValidate: nameValidate,
                    onChange: (data) {
                      if (data.toString().isEmpty) {
                        setState(() {
                          nameValidate = true;
                          emptynameValidate = true;
                        });
                      } else {}
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')), // Allow only alphabets, numbers, and spaces.
                    ],
                    hintText: "",
                    isPasswordField: false,
                    textFieldController: nameController,
                    keyboardType: TextInputType.name,
                  ),
                  Text("Email Id", style: AppStyles.textFieldText_15_w500),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextField(
                    isValidate: emailValidate,
                    textCapitalize: TextCapitalization.none,
                    textFieldController: emailAddressController,
                    focusNode: emailFocusNode,
                    errorMessage: emailValidate == true
                        ? emptyEmailValidate == true
                            ? CommonMessage.enterEmailID
                            : emailPatternValidate == true
                                ? CommonMessage.enterValidEmailID
                                : ''
                        : '',
                    onChange: (data) {
                      if (data.toString().isEmpty) {
                        emailValidate = true;
                        emptyEmailValidate = true;
                      } else {
                        if (CommonRegExps.emailRegExp.hasMatch(
                          data,
                        )) {
                          emptyEmailValidate = false;
                          emailValidate = false;
                          emailPatternValidate = false;
                        } else {
                          emptyEmailValidate = false;
                          emailValidate = true;
                          emailPatternValidate = true;
                        }
                      }
                    },
                    hintText: "",
                    isPasswordField: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Text("Contact No.", style: AppStyles.textFieldText_15_w500),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextField(
                    readOnly: true,
                    autoFocus: false,
                    focusNode: contactNumberFocusNode,
                    textCapitalize: TextCapitalization.words,
                    errorMessage: contactNumberValidate == true
                        ? emptyContactNumberValidate == true
                            ? CommonMessage.enterContact
                            : contactNumberPatternValidate == true
                                ? CommonMessage.enterValidContact
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
                    hintText: "",
                    textFieldController: contactNumberController,
                    isPasswordField: false,
                    keyboardType: TextInputType.number,
                  ),
                  Text("DOB", style: AppStyles.textFieldText_15_w500),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextField(
                    calendarToday: true,
                    focusNode: dateFocusNode,
                    readOnly: true,
                    hintText: "",
                    isPasswordField: false,
                    keyboardType: TextInputType.none,
                    textFieldController: dateController,
                    errorMessage: dateValidate == true ? CommonMessage.enterDate : '',
                    isValidate: dateValidate,
                    onChange: (data) {
                      if (data.toString().isEmpty) {
                        dateValidate = true;
                      } else {
                        dateValidate = false;
                      }
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        builder: (context, child) => Theme(
                          data: ThemeData().copyWith(
                            colorScheme: const ColorScheme.light(
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
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              textScaler: const TextScaler.linear(1.0),
                            ),
                            child: child ?? const SizedBox(),
                          ),
                        ),
                        context: context,
                        initialDate: currentDate,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        // String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                        dateValidate = false;
                        dateController.text = formattedDate;
                      } else {
                        setState(() {
                          dateValidate = true;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 400.w,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            AlertUtils.showToast("Name is required");
                          } else if (!_isValidName(nameController.text)) {
                            AlertUtils.showToast("Enter a valid name");
                          } else if (contactNumberController.text.isEmpty) {
                            AlertUtils.showToast("Mobile number is required");
                          } else if (emailAddressController.text.isEmpty) {
                            AlertUtils.showToast("Email is required");
                          } else if (!_isValidEmail(emailAddressController.text)) {
                            AlertUtils.showToast("Enter a valid email address");
                          } else if (dateController.text.isEmpty) {
                            AlertUtils.showToast("Date of birth is required");
                          } else {
                            // logger.w("STILL COMES HEREEE...");
                            updateProfileSubmitButton();
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.primary,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text('Update', style: AppStyles.white_16_w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> contactUs() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "name": contactUsNameController.text.trim(),
        "contactNo": contactUsPhoneController.text.trim(),
        "message": contactUsDescriptionController.text.trim()
      };
      BlocProvider.of<ContactUsBloc>(context).add(
        PerformContactUsEvent(
          data: body,
        ),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
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
  }

  bool _isValidName(String name) {
    // final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z0-9\s]+$'); // Only letters, numbers, and spaces.
    // final RegExp hasLettersRegex = RegExp(r'[a-zA-Z]'); // Must contain at least one letter.

    //  return validCharactersRegex.hasMatch(name) && hasLettersRegex.hasMatch(name);

    final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z\s]+$'); // Only letters and spaces.
    return validCharactersRegex.hasMatch(name);
  }

  bool _isValidPhone(String number) {
    final RegExp validPhoneRegex = RegExp(r'^\d{10}$'); // Ensures exactly 10 digits.
    final RegExp allSameDigitsRegex = RegExp(r'^(\d)\1{9}$'); // Matches repeated digits.

    return validPhoneRegex.hasMatch(number) && !allSameDigitsRegex.hasMatch(number);
  }

  File? file;

  Future<void> pickAndCropImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: AppStyles.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        ],
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
      );
      if (croppedFile != null) {
        setState(() {
          file = File(croppedFile.path);
          String fileNameWithExtension = file!.path.split('/').last;
          List<String> parts = fileNameWithExtension.split('.');
          String fileName = parts[0];
          String fileExtension = parts[1];
          if (fileName.isNotEmpty && fileExtension.isNotEmpty) {
            uploadImgButton(fileName, fileExtension);
          }
        });
      }
    }
  }

  // Future<void> pickImage1() async {
  //   final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     setState(() {
  //       file = File(image.path);
  //       String fileNameWithExtension = file.toString().split('/').last;
  //       List<String> parts = fileNameWithExtension.split('.');
  //       String fileName = parts[0];
  //       String fileExtension = parts[1];
  //       if (fileName.isNotEmpty && fileExtension.isNotEmpty) {
  //         uploadImgButton(fileName, fileExtension);
  //       }
  //     });
  //   }
  // }
  //
  // Future<void> pickImage2() async {
  //   final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       file = File(image.path);
  //       String fileNameWithExtension = file.toString().split('/').last;
  //       List<String> parts = fileNameWithExtension.split('.');
  //       String fileName = parts[0];
  //       String fileExtension = parts[1];
  //       if (fileName.isNotEmpty && fileExtension.isNotEmpty) {
  //         uploadImgButton(fileName, fileExtension);
  //       }
  //     });
  //   }
  // }

  Future<void> uploadImgButton(String fileName, String type) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "sFileName": fileName,
        "sContentType": type,
      };
      BlocProvider.of<UploadImageBloc>(context).add(
        PerformUploadImageEvent(
          data: body,
        ),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Widget bottomSheet2(BuildContext context) {
    return Container(
      height: 112.h,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 90,
        vertical: 50,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 400.w,
            child: ElevatedButton(
              onPressed: () async {
                await pickAndCropImage(ImageSource.camera);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text("import Camera", style: AppStyles.white_16_w700.copyWith(fontSize: 13.sp)),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: 400.w,
            child: ElevatedButton(
              onPressed: () async {
                await pickAndCropImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text("import Gallery", style: AppStyles.white_16_w700.copyWith(fontSize: 13.sp)),
            ),
          ),
        ],
      ),
    );
  }

  Future uploadFileApi(String url, File fileData) async {
    ApiBaseHelper? helper = ApiBaseHelper();
    int response = await helper.fileUploadPUT(url, file: fileData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.white,
      body: BlocConsumer<UploadImageBloc, UploadImageState>(
        listener: (context, state) {
          if (state.isCompleted) {
            if (file != null) {
              uploadFileApi(state.uploadImageModel?.data?.sUrl ?? "", file ?? File(''));
            }
            if (state.uploadImageModel?.data?.sPath != null) {
              var body = {
                "userImage": state.uploadImageModel?.data?.sPath ?? '',
              };
              BlocProvider.of<UpdateProfileBloc>(context).add(
                PerformUpdateProfileEvent(data: body),
              );
            }
            imagesUrl.value.add(state.uploadImageModel?.data?.sPath ?? '');
            prefs?.setString(AppConstants.profilePicture, state.uploadImageModel?.data?.sPath ?? "");
          } else if (state.isFailed) {
            AlertUtils.showToast(state.errorMsg!);
          }
        },
        builder: (context, state) {
          return BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
            listener: (context, stateD) async {
              if (stateD.isCompleted) {
                prefs?.setBool(APIConstants.deleteAccount, true) ?? false;
              } else if (stateD.isFailed) {}
            },
            builder: (context, stateD) {
              return BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
                listener: (context, state) async {
                  if (state.isCompleted) {
                    prefs?.setString(AppConstants.userName, nameController.text.trim());
                    prefs?.setString(AppConstants.userEmail, emailAddressController.text.trim());
                    prefs?.setString(AppConstants.userDOB, dateController.text.trim());
                  } else if (state.isFailed) {
                    AlertUtils.showManuallyCloseDialogue(context, state.errorMsg!, 4, 'Oops!');
                  }
                },
                builder: (context, state) {
                  return BlocConsumer<ModifyNotificationBloc, ModifyNotificationState>(
                    listener: (context, stateA) async {
                      if (stateA.isCompleted) {
                        prefs?.setBool(APIConstants.allowNotification, true);
                        // prefs.setString(
                        //     AppConstants.token,
                        //     state.model!.message!);
                      } else if (stateA.isFailed) {
                        AlertUtils.showManuallyCloseDialogue(context, state.errorMsg!, 4, 'Oops!');
                      }
                    },
                    builder: (context, stateA) {
                      return Padding(
                        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 30.h, bottom: 10.h),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 90.h,
                                width: double.infinity,
                                decoration: BoxDecoration(color: AppStyles.primary, borderRadius: BorderRadius.circular(11)),
                                child: ListTile(
                                  leading: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet2(context)),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(27.h),
                                        child: Container(
                                          height: 54.h,
                                          width: 54.h,
                                          // decoration: BoxDecoration(
                                          //   borderRadius: BorderRadius.circular(11),
                                          // ),
                                          child: file != null
                                              ? Image.file(
                                                  file!,
                                                  height: 35.h,
                                                  fit: BoxFit.fill,
                                                )
                                              : apiImg != ''
                                                  ? CachedNetworkImage(
                                                      height: 54.h,
                                                      width: 54.h,
                                                      fit: BoxFit.fill,
                                                      progressIndicatorBuilder: (context, url, progress) => Center(
                                                        child: CircularProgressIndicator(
                                                          value: progress.progress,
                                                          color: AppStyles.white,
                                                        ),
                                                      ),
                                                      imageUrl: '${APIConstants.imageUrl}${apiImg}',
                                                    )
                                                  : Image.asset(
                                                      ImageAssetPath.memberImage,
                                                      // ImageAssetPath.memberImage
                                                      height: 35.h,
                                                      fit: BoxFit.fill,
                                                    ),
                                          // file != File("")
                                          //     ? Image.asset(
                                          //   // ImagePath.productDetail,
                                          //   ImageAssetPath.memberImage,
                                          //   height: 40.h,
                                          //   // scale: 0.8,
                                          //   fit: BoxFit.fill,
                                          // )
                                          //     : Image.file(
                                          //   file!,
                                          //   height: 2.h,
                                          //   width: 100.w,
                                          //   fit: BoxFit.fill,
                                          // )
                                        ),
                                      )),
                                  // trailing: Icon(
                                  //   Icons.arrow_forward_ios_outlined,
                                  //   color: AppStyles.white,
                                  //   size: 20.h,
                                  // ),
                                  title: Text(
                                    nameController.text,
                                    style: AppStyles.white_16_w700.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    emailAddressController.text,
                                    style: AppStyles.white_15_w500.copyWith(fontSize: 13.sp),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                // height: 300.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppStyles.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppStyles.bordercolor.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h, bottom: 10.h),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(25.0),
                                              ),
                                            ),
                                            builder: (context) => Padding(
                                              padding: MediaQuery.of(context).viewPadding,
                                              child: personalInformationBottomSheet(context),
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                          contentPadding: EdgeInsets.zero,
                                          leading: SvgPicture.asset(ImageAssetPath.profilePersonalInformationSvg),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppStyles.black,
                                            size: 15.h,
                                          ),
                                          title: Text(
                                            "Personal Information",
                                            style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, AppScreens.savedAddress,
                                              arguments: {'fromShopping': false, 'fromDrawer': false});
                                        },
                                        child: ListTile(
                                          // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                          contentPadding: EdgeInsets.zero,
                                          leading: SvgPicture.asset(
                                            ImageAssetPath.addAddressesSvg,
                                            color: Colors.black,
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppStyles.black,
                                            size: 15.h,
                                          ),
                                          title: Text(
                                            "Saved Address",
                                            style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(25.0),
                                              ),
                                            ),
                                            builder: (context) => Padding(
                                              // Use viewInsets to adjust the position when the keyboard is open
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom, // This adjusts the bottom sheet to sit above the keyboard
                                              ),
                                              child: contactUsBottomSheet(context),
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                          contentPadding: EdgeInsets.zero,
                                          leading: SvgPicture.asset(ImageAssetPath.profileContactUsSvg),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppStyles.black,
                                            size: 15.h,
                                          ),
                                          title: Text(
                                            "Contact Us",
                                            style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, AppScreens.helpAndFaqs);
                                        },
                                        child: ListTile(
                                          // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                          contentPadding: EdgeInsets.zero,
                                          leading: SvgPicture.asset(ImageAssetPath.profileHelpSvg),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppStyles.black,
                                            size: 15.h,
                                          ),
                                          title: Text(
                                            "Help & FAQs",
                                            style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                          ),
                                        ),
                                      ),
                                      // Divider(),
                                      // ListTile(
                                      //   // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                      //   contentPadding: EdgeInsets.zero,
                                      //   leading: SvgPicture.asset(ImageAssetPath.profileSettingsSvg),
                                      //   trailing: Icon(
                                      //     Icons.arrow_forward_ios_outlined,
                                      //     color: AppStyles.black,
                                      //     size: 15.h,
                                      //   ),
                                      //   title: Text(
                                      //     "Settings",
                                      //     style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Container(
                                // height: 230.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppStyles.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppStyles.bordercolor.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h, bottom: 10.h),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
                                        leading: SvgPicture.asset(ImageAssetPath.profileNotificationSvg),
                                        title: Text(
                                          "Notification",
                                          style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                        ),
                                        trailing: Transform.scale(
                                          scale: 1.1,
                                          // Adjust this value to change the size of the switch
                                          child: Switch(
                                            value: isSelect,
                                            activeColor: AppStyles.primary,
                                            activeTrackColor: AppStyles.switchColor,
                                            inactiveThumbColor: AppStyles.white,
                                            inactiveTrackColor: AppStyles.switchColor,
                                            onChanged: (value) {
                                              setState(() {
                                                isSelect = value;
                                                allowNotificationButton();
                                                prefs?.setBool(AppConstants.allowNotification, isSelect) ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          _showDeleteConfirmationDialog(context);
                                        },
                                        // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                        contentPadding: EdgeInsets.zero,
                                        leading: Icon(Icons.delete_outlined),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppStyles.black,
                                          size: 15.h,
                                        ),
                                        title: Text(
                                          "Delete Account",
                                          style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        onTap: () {
                                          _showLogoutConfirmationDialog(context);
                                        },
                                        // visualDensity: VisualDensity(vertical: -4.h, horizontal: -4.w),
                                        contentPadding: EdgeInsets.zero,
                                        leading: SvgPicture.asset(ImageAssetPath.profileLogoutSvg),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppStyles.black,
                                          size: 15.h,
                                        ),
                                        title: Text(
                                          "Logout",
                                          style: AppStyles.black_17_w600.copyWith(fontWeight: FontWeight.w500, fontSize: 15.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
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

  allowNotificationButton() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<ModifyNotificationBloc>(context).add(PerformModifyNotificationEvent());
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  deleteAccountButton() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<DeleteAccountBloc>(context).add(PerformDeleteAccountEvent());
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> updateProfileSubmitButton() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "mobileNumber": contactNumberController.text,
        "name": nameController.text,
        "email": emailAddressController.text,
        "dob": dateController.text,
      };

      BlocProvider.of<UpdateProfileBloc>(context).add(
        PerformUpdateProfileEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

// Future UploadDocumentForPreURL(File file, int type) async {
//   String fileName = file.path.split('/').last;
//   String fileType = file.path.split('.').last;
//   var data = {"sFileName": fileName, "sContentType": fileType};
//   print(data);
//   showUploadLoader.add(true);
//   BlocProvider.of<UploadImageBloc>(context).add(
//     PerformUploadImageEvent(data: data, type: type),
//   );
// }
//
// uploadFileFromDio(String uploadUrl, File file, int type, List<File> pickedImage) async {
//   ApiBaseHelper? _helper = ApiBaseHelper();
//   D.Response response = await _helper.fileUploadPUT(uploadUrl, file: file, onProgress: (currentP, totalP) {
//     print("PROGRESS ${currentP} ${totalP}");
//     StreamUtil.progress.add(currentP);
//     StreamUtil.total.add(totalP);
//     if (StreamUtil.progress.value == totalP) {
//       StreamUtil.progress.add(0);
//       StreamUtil.total.add(0);
//       completedUpload.add(completedUpload.value + 1);
//     }
//   });

// if (response.statusCode == 200) {
//   if (completedUpload.value != pickedImage.length) {
//     await UploadDocumentForPreURL(pickedImage[completedUpload.value], completedUpload.value);
//   } else {
//     showUploadLoader.add(false);
//     showLoading.add(true);
//     final TranslationService _translationService = TranslationService();
//     String? encategory = AppHelper.itemsCategory.where((element) => element.id == catagoryId.value).first.name!;
//     String enState =
//     await _translationService.translate(text: selectStateController.text.trim(), targetLanguage: 'en');
//     String encountry =
//     await _translationService.translate(text: selectContryController.text.trim(), targetLanguage: 'en');
//     String entitile = await _translationService.translate(text: titile.text.trim(), targetLanguage: 'en');
//     String enDiscription =
//     await _translationService.translate(text: descriptioncontroller.text.trim(), targetLanguage: 'en');
//
//     var body = {
//       "category": encategory,
//       "price": pricecontroller.text.trim(),
//       "country": encountry,
//       "subrub": enState,
//       "acceptsOffer": offer.value,
//       "title": entitile,
//       "description": enDiscription,
//       "itemImage": imagesUrl.value,
//       "currency": StreamUtil.selectedCurrency.value //link of images
//     };
//     var internet = await AppUtils.checkInternet();
//
//     if (internet) {
//       if (widget.id == '') {
//         BlocProvider.of<CreateItemBloc>(context).add(PerformCreateItemEvent(data: body));
//       } else {
//         BlocProvider.of<UpdateItemBloc>(context).add(PerformUpdateItemEvent(data: body, id: widget.id!));
//       }
//     } else {
//       AlertUtils.showNotInternetDialogue(context);
//     }
//   }
// }
// }
}
