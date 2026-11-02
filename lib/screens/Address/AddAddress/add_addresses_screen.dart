import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app_screens/app_screens.dart';
import '../../../constants/app_constants.dart';
import '../../../utils/alert_utils.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/custom_textfield.dart';
import '../update_address/bloc/update_address_bloc.dart';
import '../get_address/bloc/get_address_bloc.dart';
import 'bloc/add_address_bloc.dart';
import 'bloc/add_address_event.dart';
import 'bloc/add_address_state.dart';

class AddAddressesScreen extends StatefulWidget {
  String id;
  String house;
  String landMark;
  String area;
  String city;
  String pinCode;

  AddAddressesScreen(
      {super.key, required this.id, required this.house, required this.landMark, required this.city, required this.pinCode, required this.area});

  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetAddressScreenBloc>(create: (_) => GetAddressScreenBloc()),
        BlocProvider<UpdateAddressBloc>(create: (_) => UpdateAddressBloc()),
        BlocProvider(
          create: (context) => AddAddressBloc(),
        ),
      ],
      child: AddAddressesScreen(
        id: '',
        pinCode: '',
        landMark: '',
        house: '',
        area: '',
        city: '',
      ),
    );
  }

  @override
  State<AddAddressesScreen> createState() => _AddAddressesScreenState();
}

class _AddAddressesScreenState extends State<AddAddressesScreen> {
  TextEditingController houseNoController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    if (widget.pinCode == 0) {
      pinCodeController.text = "";
    } else if (widget.id != 0 || widget.house != '' || widget.area != '' || widget.pinCode != '') {
      houseNoController.text = widget.house;
      pinCodeController.text = widget.pinCode.toString();
      cityController.text = widget.city;
      areaController.text = widget.area;
      landmarkController.text = widget.landMark;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primary,
      body: BlocConsumer<AddAddressBloc, AddAddressState>(
        listener: (context, state) async {
          if (state.isCompleted) {
            AlertUtils.showToast("Address Added Successfully");
            // BlocProvider.of<GetAddressScreenBloc>(context).add(
            //   PerformGetAddressScreenEvent(),
            // );
            // Navigator.pushReplacementNamed(context, AppScreens.savedAddress, arguments: {'fromShopping': false});
            Navigator.pop(context, true);
          } else if (state.isFailed) {}
        },
        builder: (context, state) {
          return BlocConsumer<GetAddressScreenBloc, GetAddressScreenState>(
            listener: (context, getAddressState) {},
            builder: (context, getAddressState) {
              return BlocConsumer<UpdateAddressBloc, UpdateAddressState>(
                listener: (context, updateState) {
                  if (updateState.isCompleted) {
                    BlocProvider.of<GetAddressScreenBloc>(context).add(
                      PerformGetAddressScreenEvent(),
                    );
                    AlertUtils.showToast("Address Updated Successfully");
                    Navigator.pop(context, true);
                    // prefs?.setBool(APIConstants.updateProfile, true);
                  } else if (updateState.isFailed) {}
                },
                builder: (context, updateState) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 150.h,
                              color: AppStyles.primary,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.arrow_back,
                                        color: AppStyles.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70.w,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Add Address",
                                        textAlign: TextAlign.center,
                                        style: AppStyles.white_24_w400.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
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
                                padding: EdgeInsets.only(top: 50.h, left: 40.w, right: 40.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("House", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                       textCapitalize: TextCapitalization.words,

                                      hintText: "",
                                      isPasswordField: false,
                                      textFieldController: houseNoController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    Text("Landmark", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                       textCapitalize: TextCapitalization.words,
                                      hintText: "",
                                      isPasswordField: false,
                                      textFieldController: landmarkController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    Text("Area", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                      textCapitalize: TextCapitalization.words,
                                      hintText: "",
                                      isPasswordField: false,
                                      textFieldController: areaController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    Text("City", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                      textCapitalize: TextCapitalization.words,
                                      hintText: "",
                                      isPasswordField: false,
                                      textFieldController: cityController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    Text("PinCode", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                      textCapitalize: TextCapitalization.words,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      hintText: "",
                                      isPasswordField: false,
                                      textFieldController: pinCodeController,
                                      keyboardType: TextInputType.number,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: 300.w,
                                        height: 55.h,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (houseNoController.text.isEmpty) {
                                              AlertUtils.showToast("House number should not be empty.");
                                            }  else if (!_isValidHouseNo(houseNoController.text)) {
                                              AlertUtils.showToast("Please enter a valid house number.");
                                            }else if (landmarkController.text.isEmpty) {
                                              AlertUtils.showToast("Landmark should not be empty.");
                                            }  else if (!_isValidLandmark(landmarkController.text)) {
                                              AlertUtils.showToast("Please enter a valid landmark.");
                                            }else if (areaController.text.isEmpty) {
                                              AlertUtils.showToast("Area should not be empty.");

                                            } else if (!_isValidName(areaController.text)) {
                                              AlertUtils.showToast("Please enter a valid area");
                                            } else if (cityController.text.isEmpty) {
                                              AlertUtils.showToast("City should not be empty.");
                                            }  else if (!_isValidName(cityController.text)) {
                                              AlertUtils.showToast("Please enter a valid city name.");
                                            }else if (pinCodeController.text.isEmpty) {
                                              AlertUtils.showToast("PinCode should not be empty.");
                                            } else {
                                              widget.id != '' ? updateAddressSubmitButton() : saveAddressSubmitButton();
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
                                            widget.id != '' ? 'Update' : 'Save',
                                            style: AppStyles.white_16_w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                  ],
                                ),
                              ),
                              // color: AppStyles.white,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        child: LoaderWidget(),
                        visible: state.isLoading || updateState.isLoading,
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  bool _isValidName(String name) {
    final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z\s]+$'); // Only letters and spaces.
    return validCharactersRegex.hasMatch(name);
  }
  bool _isValidHouseNo(String name) {
    final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z0-9\s]+$'); // Only letters, numbers, and spaces.

    return validCharactersRegex.hasMatch(name); // Ensures only valid characters.
  }

  bool _isValidLandmark(String name) {
    final RegExp validCharactersRegex = RegExp(r'^[a-zA-Z0-9\s]+$'); // Only letters, numbers, and spaces.
    final RegExp hasLettersRegex = RegExp(r'[a-zA-Z]'); // Must contain at least one letter.
    final RegExp hasNumbersRegex = RegExp(r'[0-9]'); // Must contain at least one number.

    return validCharactersRegex.hasMatch(name) && hasLettersRegex.hasMatch(name) && !hasNumbersRegex.hasMatch(name.trim());
  }

  Future<void> saveAddressSubmitButton() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "house": houseNoController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "area": areaController.text.trim(),
        "city": cityController.text.trim(),
        "pinCode": pinCodeController.text.trim().toString(),
      };
      BlocProvider.of<AddAddressBloc>(context).add(
        PerformAddAddressEvent(data: body),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> updateAddressSubmitButton() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = {
        "house": houseNoController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "area": areaController.text.trim(),
        "city": cityController.text.trim(),
        "pinCode": pinCodeController.text.trim().toString(),
      };

      BlocProvider.of<UpdateAddressBloc>(context).add(
        PerformUpdateAddressEvent(data: body, id: widget.id),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
