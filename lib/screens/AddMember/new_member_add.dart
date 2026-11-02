import 'package:Digibells/screens/AddMember/add_member/bloc/add_member_event.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_constants.dart';
import '../../constants/common_regExps.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_textfield.dart';
import 'add_member/bloc/add_member_bloc.dart';
import 'add_member/bloc/add_member_state.dart';

class NewMemberAddScreen extends StatefulWidget {
  const NewMemberAddScreen({super.key});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddMemberBloc>(create: (_) => AddMemberBloc()),
      ],
      child: NewMemberAddScreen(),
    );
  }

  @override
  State<NewMemberAddScreen> createState() => _NewMemberAddScreenState();
}

class _NewMemberAddScreenState extends State<NewMemberAddScreen> {
  DateTime currentDate = DateTime.now();

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  TextEditingController contactNumberController = TextEditingController();
  FocusNode contactNumberFocusNode = FocusNode();

  // String formateDate = "null";
  // String formattedTime = "null";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primary,
      body: BlocConsumer<AddMemberBloc, AddMemberState>(
        listener: (context, state) {
          if (state.isCompleted) {
            AlertUtils.showToast("Invite send successfully.");
            Navigator.pop(context);
          } else if (state.isFailed) {
            AlertUtils.showToast(state.errorMsg ?? 'Something went wrong');
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 140.h,
                  color: AppStyles.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: AppStyles.white,
                              ),
                            ),
                            SizedBox(
                              width: 70.w,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 180.w,
                                child: Text(
                                  "Add Member",
                                  textAlign: TextAlign.center,
                                  style: AppStyles.white_24_w400.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 705.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: state.isLoading
                      ? LoaderWidget()
                      : Padding(
                          padding: EdgeInsets.only(top: 40.h, left: 25.w, right: 25.w),
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
                                hintText: "Enter Name",
                                isPasswordField: false,
                                textFieldController: nameController,
                                keyboardType: TextInputType.name,
                              ),
                              Text("Contact Number", style: AppStyles.textFieldText_15_w500),
                              SizedBox(
                                height: 15.h,
                              ),
                              CustomTextField(
                                autoFocus: false,
                                focusNode: contactNumberFocusNode,
                                textCapitalize: TextCapitalization.words,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                hintText: "Enter Contact Number",
                                textFieldController: contactNumberController,
                                isPasswordField: false,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 300.w,
                                  height: 55.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus;
                                      if (nameController.text.isEmpty) {
                                        AlertUtils.showToast("Name should not be empty.");
                                        //FocusScope.of(context).requestFocus(nameFocusNode);
                                      } else if (!_isValidName(nameController.text)) {
                                        // FocusScope.of(context).requestFocus(nameFocusNode);
                                        AlertUtils.showToast("Please enter a valid name.");
                                      } else if (contactNumberController.text.isEmpty) {
                                        AlertUtils.showToast("Contact number should not be empty.");
                                        //FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                      } else if (!_isValidPhone(contactNumberController.text)) {
                                        AlertUtils.showToast("Please enter a valid contact number.");
                                        // FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                      } else {
                                        sendInvite();
                                      }
                                      // Navigator.of(context).pop();
                                      // Navigator.pushNamed(
                                      //   context,
                                      //   AppScreens.firstTimeHomeScreen,
                                      // );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppStyles.primary,
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text('Send Invite', style: AppStyles.white_16_w700),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isValidName(String name) {
    final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z\s]+$'); // Only letters and spaces.
    return validCharactersRegex.hasMatch(name);
  }

  bool _isValidPhone(String number) {
    final RegExp validPhoneRegex = RegExp(r'^\d{10}$'); // Ensures exactly 10 digits.
    final RegExp allSameDigitsRegex = RegExp(r'^(\d)\1{9}$'); // Matches repeated digits.

    return validPhoneRegex.hasMatch(number) && !allSameDigitsRegex.hasMatch(number);
  }

  Future<void> sendInvite() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "name": nameController.text.trim(),
        "mobileNumber": contactNumberController.text.trim(),
      };

      BlocProvider.of<AddMemberBloc>(context).add(
        PerformAddMemberEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
