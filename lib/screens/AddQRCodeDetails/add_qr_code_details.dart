import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/bloc/update_qr_details_bloc.dart';
import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/bloc/update_qr_details_event.dart';
import 'package:Digibells/screens/AddQRCodeDetails/update_qr_details/bloc/update_qr_details_state.dart';
import 'package:Digibells/utils/logger.dart';
import 'package:Digibells/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_screens/app_screens.dart';
import '../../constants/app_constants.dart';
import '../../constants/common_regExps.dart';
import '../../main.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_styles.dart';
import '../../utils/app_utils.dart';
import '../../utils/custom_textfield.dart';
import '../../utils/stream_builder.dart';
import '../HomeScreen/get_all_qr_details/model/get_all_qr_details_model.dart';
import 'add_qr_details/bloc/add_qr_details_bloc.dart';
import 'add_qr_details/bloc/add_qr_details_event.dart';
import 'add_qr_details/bloc/add_qr_details_state.dart';

class AddQrCodeDetails extends StatefulWidget {
  bool isUpdate;
  bool firstQR;
  int index;
  GetAllQRList qrDetails;
  AddQrCodeDetails({super.key, required this.isUpdate, required this.index, required this.qrDetails, required this.firstQR});
  static Widget create() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AddQRDetailsBloc>(create: (_) => AddQRDetailsBloc()),
        BlocProvider<UpdateQRDetailsBloc>(create: (_) => UpdateQRDetailsBloc()),
      ],
      child: AddQrCodeDetails(
        index: 0,
        isUpdate: false,
        firstQR: false,
        qrDetails: GetAllQRList(),
      ),
    );
  }

  @override
  State<AddQrCodeDetails> createState() => _AddQrCodeDetailsState();
}

class _AddQrCodeDetailsState extends State<AddQrCodeDetails> with SingleTickerProviderStateMixin {
  bool isSelect = true;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.index = widget.index;
    if (widget.isUpdate == true) {
      nameController.text = widget.qrDetails.name ?? '';
      contactNumberController.text = widget.qrDetails.contactNumber.toString() ?? '';
      addressController.text = widget.qrDetails.address ?? '';
      stateController.text = widget.qrDetails.state ?? '';
      cityController.text = widget.qrDetails.city ?? '';
      pinCodeController.text = widget.qrDetails.pincode ?? '';
      hotelNameController.text = widget.qrDetails.hotelName ?? '';
      hotelContactController.text = widget.qrDetails.hotelContactNumber.toString() ?? '';
      otherDetailsController.text = widget.qrDetails.otherDetails ?? '';
      vehicleNumberController.text = widget.qrDetails.carNumber ?? '';
    } else if (widget.firstQR == true) {
      contactNumberController.text = prefs?.getString(AppConstants.userContact) ?? '';
    }
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();

  TextEditingController contactNumberController = TextEditingController();
  FocusNode contactNumberFocusNode = FocusNode();

  TextEditingController addressController = TextEditingController();
  FocusNode addressFocusNode = FocusNode();

  TextEditingController stateController = TextEditingController();
  FocusNode stateFocusNode = FocusNode();

  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();

  TextEditingController pinCodeController = TextEditingController();
  FocusNode pinCodeFocusNode = FocusNode();

  TextEditingController vehicleNumberController = TextEditingController();
  FocusNode vehicleNumberFocusNode = FocusNode();

  TextEditingController otherDetailsController = TextEditingController();
  FocusNode otherDetailsFocusNode = FocusNode();

  TextEditingController hotelNameController = TextEditingController();
  FocusNode hotelNameFocusNode = FocusNode();

  TextEditingController hotelContactController = TextEditingController();
  FocusNode hotelContactFocusNode = FocusNode();

  clearCTRL() {
    if (widget.firstQR != true) {
      contactNumberController.clear();
    }
    hotelContactController.clear();
    nameController.clear();
    hotelNameController.clear();
    otherDetailsController.clear();
    vehicleNumberController.clear();
    pinCodeController.clear();
    cityController.clear();
    stateController.clear();
    addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primary,
      body: BlocConsumer<AddQRDetailsBloc, AddQRDetailsState>(
        listener: (context, state) {
          if (state.isCompleted) {
            AlertUtils.showToast('QR Code details generated successfully.');
            Navigator.pushNamed(
              context,
              AppScreens.firstTimeHomeScreen,
            );
            StreamUtil.bottomNavigationIndex.add(0);
          }
        },
        builder: (context, state) {
          return BlocConsumer<UpdateQRDetailsBloc, UpdateQRDetailsState>(
            listener: (context, updateState) {
              if (updateState.isCompleted) {
                AlertUtils.showToast('QR Code details updated successfully.');
                Navigator.pushNamed(
                  context,
                  AppScreens.firstTimeHomeScreen,
                );
                StreamUtil.bottomNavigationIndex.add(0);
              }
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
                                    Navigator.pop(context);
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
                                      textAlign: TextAlign.center,
                                      widget.isUpdate == true ? "Update QR code details" : "Add QR code details",
                                      style: AppStyles.white_24_w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.h, left: 30.w, right: 30.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Type", style: AppStyles.textFieldText_15_w500),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  height: 60.h,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: TabBar(
                                    dividerColor: Colors.transparent,
                                    labelPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.0.h),
                                    controller: _tabController,
                                    onTap: (value) {
                                      if (widget.isUpdate == false) {
                                        logger.w("Allow tab change");
                                        // Allow tab change
                                        setState(() {});
                                        clearCTRL();
                                      } else {
                                        logger.w("no tab change");
                                        // Prevent tab change by resetting the index to the current tab
                                        Future.delayed(Duration.zero, () {
                                          _tabController.animateTo(widget.index);
                                        });
                                      }
                                    },
                                    indicator: BoxDecoration(
                                      color: AppStyles.activeTabColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    labelColor: AppStyles.white,
                                    unselectedLabelColor: widget.isUpdate ? Colors.grey : AppStyles.primary,
                                    labelStyle: AppStyles.red_16_w300.copyWith(
                                      color: AppStyles.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    unselectedLabelStyle: AppStyles.red_16_w300.copyWith(
                                      color: widget.isUpdate ? Colors.grey : AppStyles.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    automaticIndicatorColorAdjustment: true,
                                    tabs: [
                                      Tab(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: widget.isUpdate && widget.index != 0 ? Colors.grey : AppStyles.activeTabColor),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text('Home'),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: widget.isUpdate && widget.index != 1 ? Colors.grey : AppStyles.activeTabColor),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text('Hotel'),
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: widget.isUpdate && widget.index != 2 ? Colors.grey : AppStyles.activeTabColor),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text('Car'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 10.h,
                                ),
                                Text("Name", style: AppStyles.textFieldText_15_w500),
                                SizedBox(
                                  height: 15.h,
                                ),
                                CustomTextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                  ],
                                  autoFocus: false,
                                  focusNode: nameFocusNode,
                                  textCapitalize: TextCapitalization.words,
                                  hintText: "",
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
                                  readOnly: widget.firstQR == true ? true : false,
                                  focusNode: contactNumberFocusNode,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  hintText: "",
                                  textFieldController: contactNumberController,
                                  isPasswordField: false,
                                  keyboardType: TextInputType.number,
                                ),
                                if (_tabController.index == 0 || _tabController.index == 1) ...[
                                  if (_tabController.index == 1) ...[
                                    Text("Hotel Name", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                      focusNode: hotelNameFocusNode,
                                      textCapitalize: TextCapitalization.words,
                                      hintText: "",
                                      isPasswordField: false,
                                      textFieldController: hotelNameController,
                                      keyboardType: TextInputType.name,
                                    ),
                                    Text("Hotel Contact Number", style: AppStyles.textFieldText_15_w500),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    CustomTextField(
                                      autoFocus: false,
                                      focusNode: hotelContactFocusNode,
                                      textCapitalize: TextCapitalization.words,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      hintText: "",
                                      textFieldController: hotelContactController,
                                      isPasswordField: false,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                  Text("Address ( Area & Street )", style: AppStyles.textFieldText_15_w500),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomTextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                                    ],
                                    autoFocus: false,
                                    focusNode: addressFocusNode,
                                    textCapitalize: TextCapitalization.words,
                                    hintText: "",
                                    isPasswordField: false,
                                    textFieldController: addressController,
                                    keyboardType: TextInputType.name,
                                  ),
                                  Text("City/District/Town", style: AppStyles.textFieldText_15_w500),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomTextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                    ],
                                    autoFocus: false,
                                    focusNode: cityFocusNode,
                                    textCapitalize: TextCapitalization.words,
                                    hintText: "",
                                    isPasswordField: false,
                                    textFieldController: cityController,
                                    keyboardType: TextInputType.name,
                                  ),
                                  Text("State", style: AppStyles.textFieldText_15_w500),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomTextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                    ],
                                    autoFocus: false,
                                    focusNode: stateFocusNode,
                                    textCapitalize: TextCapitalization.words,
                                    hintText: "",
                                    isPasswordField: false,
                                    textFieldController: stateController,
                                    keyboardType: TextInputType.name,
                                  ),
                                  Text("PinCode", style: AppStyles.textFieldText_15_w500),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomTextField(
                                    autoFocus: false,
                                    focusNode: pinCodeFocusNode,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    hintText: "",
                                    isPasswordField: false,
                                    textFieldController: pinCodeController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                ] else ...[
                                  Text("Enter Vehicle Number", style: AppStyles.textFieldText_15_w500),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomTextField(
                                    autoFocus: false,
                                    focusNode: vehicleNumberFocusNode,
                                    textCapitalize: TextCapitalization.words,
                                    inputFormatter: [
                                      // FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(12),
                                    ],
                                    hintText: "",
                                    isPasswordField: false,
                                    textFieldController: vehicleNumberController,
                                    keyboardType: TextInputType.name,
                                  ),
                                  Text("Other Details", style: AppStyles.textFieldText_15_w500),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  CustomTextField(
                                    autoFocus: false,
                                    focusNode: otherDetailsFocusNode,
                                    textCapitalize: TextCapitalization.words,
                                    hintText: "",
                                    isPasswordField: false,
                                    textFieldController: otherDetailsController,
                                    keyboardType: TextInputType.name,
                                  ),
                                ],
                                Center(
                                  child: SizedBox(
                                    width: 300.w,
                                    height: 55.h,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus;
                                        if (_tabController.index == 0) {
                                          if (nameController.text.isEmpty) {
                                            AlertUtils.showToast("Name should not be empty.");
                                            // FocusScope.of(context).requestFocus(nameFocusNode);
                                          } else if (!_isValidName(nameController.text)) {
                                            AlertUtils.showToast("Please enter a valid name.");
                                            // FocusScope.of(context).requestFocus(nameFocusNode);
                                          } else if (contactNumberController.text.isEmpty) {
                                            AlertUtils.showToast("Contact number should not be empty.");
                                            // FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                          } else if (!_isValidPhone(contactNumberController.text)) {
                                            AlertUtils.showToast("Please enter a valid contact number.");
                                            //FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                          } else if (addressController.text.isEmpty) {
                                            AlertUtils.showToast("Address should not be empty.");
                                            //FocusScope.of(context).requestFocus(addressFocusNode);
                                          } else if (cityController.text.isEmpty) {
                                            AlertUtils.showToast("City/District/Town should not be empty.");
                                            // FocusScope.of(context).requestFocus(cityFocusNode);
                                          } else if (!_isValidName(cityController.text)) {
                                            AlertUtils.showToast("Please enter a valid City/District/Town.");
                                            //FocusScope.of(context).requestFocus(cityFocusNode);
                                          } else if (stateController.text.isEmpty) {
                                            AlertUtils.showToast("State should not be empty.");
                                            //FocusScope.of(context).requestFocus(stateFocusNode);
                                          } else if (!_isValidName(stateController.text)) {
                                            AlertUtils.showToast("Please enter a valid state.");
                                            //FocusScope.of(context).requestFocus(stateFocusNode);
                                          } else if (pinCodeController.text.isEmpty) {
                                            AlertUtils.showToast("PinCode should not be empty.");
                                            //FocusScope.of(context).requestFocus(pinCodeFocusNode);
                                          } else {
                                            var type = _tabController.index == 0
                                                ? 'home'
                                                : _tabController.index == 1
                                                    ? 'hotel'
                                                    : 'car';
                                            widget.isUpdate == true ? updateQRDetails() : submitQRDetails(type);
                                          }
                                        } else if (_tabController.index == 1) {
                                          if (nameController.text.isEmpty) {
                                            AlertUtils.showToast("Name should not be empty.");
                                            //FocusScope.of(context).requestFocus(nameFocusNode);
                                          } else if (!_isValidName(nameController.text)) {
                                            AlertUtils.showToast("Please enter a valid name.");
                                            //FocusScope.of(context).requestFocus(nameFocusNode);
                                          } else if (contactNumberController.text.isEmpty) {
                                            AlertUtils.showToast("Contact number should not be empty.");
                                            // FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                          } else if (!_isValidPhone(contactNumberController.text)) {
                                            AlertUtils.showToast("Please enter a valid contact number.");
                                            // FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                          } else if (hotelNameController.text.isEmpty) {
                                            AlertUtils.showToast("Hotel name should not be empty.");
                                            // FocusScope.of(context).requestFocus(hotelNameFocusNode);
                                          } else if (!_isValidName(hotelNameController.text)) {
                                            AlertUtils.showToast("Please enter a valid hotel name.");
                                            // FocusScope.of(context).requestFocus(hotelNameFocusNode);
                                          } else if (hotelContactController.text.isEmpty) {
                                            AlertUtils.showToast("Hotel phone no. should not be empty.");
                                            // FocusScope.of(context).requestFocus(hotelContactFocusNode);
                                          } else if (!_isValidPhone(hotelContactController.text)) {
                                            AlertUtils.showToast("Please enter a valid hotel phone no.");
                                            // FocusScope.of(context).requestFocus(hotelContactFocusNode);
                                          } else if (addressController.text.isEmpty) {
                                            AlertUtils.showToast("Address should not be empty.");
                                            //FocusScope.of(context).requestFocus(addressFocusNode);
                                          } else if (cityController.text.isEmpty) {
                                            AlertUtils.showToast("City/District/Town should not be empty.");
                                            //FocusScope.of(context).requestFocus(cityFocusNode);
                                          } else if (!_isValidName(cityController.text)) {
                                            AlertUtils.showToast("Please enter a valid City/District/Town.");
                                            //FocusScope.of(context).requestFocus(cityFocusNode);
                                          } else if (stateController.text.isEmpty) {
                                            AlertUtils.showToast("State should not be empty.");
                                            //FocusScope.of(context).requestFocus(stateFocusNode);
                                          } else if (!_isValidName(stateController.text)) {
                                            AlertUtils.showToast("Please enter a valid state.");
                                            //FocusScope.of(context).requestFocus(stateFocusNode);
                                          } else if (pinCodeController.text.isEmpty) {
                                            AlertUtils.showToast("PinCode should not be empty.");
                                            //FocusScope.of(context).requestFocus(pinCodeFocusNode);
                                          } else {
                                            var type = _tabController.index == 0
                                                ? 'home'
                                                : _tabController.index == 1
                                                    ? 'hotel'
                                                    : 'car';
                                            widget.isUpdate == true ? updateQRDetails() : submitQRDetails(type);
                                          }
                                        } else {
                                          if (nameController.text.isEmpty) {
                                            AlertUtils.showToast("Name should not be empty.");
                                            //FocusScope.of(context).requestFocus(nameFocusNode);
                                          } else if (!_isValidName(nameController.text)) {
                                            AlertUtils.showToast("Please enter a valid name.");
                                            // FocusScope.of(context).requestFocus(nameFocusNode);
                                          } else if (contactNumberController.text.isEmpty) {
                                            AlertUtils.showToast("Contact number should not be empty.");
                                            //FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                          } else if (!_isValidPhone(contactNumberController.text)) {
                                            AlertUtils.showToast("Please enter a valid contact number.");
                                            //FocusScope.of(context).requestFocus(contactNumberFocusNode);
                                          } else if (vehicleNumberController.text.isEmpty) {
                                            AlertUtils.showToast("Vehicle number should not be empty.");
                                            // FocusScope.of(context).requestFocus(vehicleNumberFocusNode);
                                          } else {
                                            var type = _tabController.index == 0
                                                ? 'home'
                                                : _tabController.index == 1
                                                    ? 'hotel'
                                                    : 'car';
                                            widget.isUpdate == true ? updateQRDetails() : submitQRDetails(type);
                                          }
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
                                        widget.isUpdate == true ? 'Update' : 'Submit',
                                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                // Expanded(
                                //   child: TabBarView(
                                //     controller: _tabController,
                                //     children: [
                                //       HomeData(),
                                //       HomeData(),
                                //       HomeData(),
                                //     ],
                                //   ),
                                // ),
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

  Future<void> submitQRDetails(dynamic type) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = type == 'home'
          ? {
              "type": type,
              "name": nameController.text.trim(),
              'contactNumber': contactNumberController.text.trim(),
              "address": addressController.text.trim(),
              "state": stateController.text.trim(),
              "city": cityController.text.trim(),
              "pincode": pinCodeController.text.trim()
            }
          : type == 'hotel'
              ? {
                  "type": type,
                  "name": nameController.text.trim(),
                  'hotelName': hotelNameController.text.trim(),
                  'hotelContactNumber': hotelContactController.text.trim(),
                  'contactNumber': contactNumberController.text.trim(),
                  "address": addressController.text.trim(),
                  "state": stateController.text.trim(),
                  "city": cityController.text.trim(),
                  "pincode": pinCodeController.text.trim(),
                }
              : {
                  "type": type,
                  "name": nameController.text.trim(),
                  'otherDetails': otherDetailsController.text.trim(),
                  'carNumber': vehicleNumberController.text.trim(),
                  'contactNumber': contactNumberController.text.trim(),
                };

      BlocProvider.of<AddQRDetailsBloc>(context).add(
        PerformAddQRDetailsEvent(
          data: body,
        ),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> updateQRDetails() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      var body = widget.qrDetails.type == 'home'
          ? {
              "name": nameController.text.trim(),
              'contactNumber': contactNumberController.text.trim(),
              "address": addressController.text.trim(),
              "state": stateController.text.trim(),
              "city": cityController.text.trim(),
              "pincode": pinCodeController.text.trim()
            }
          : widget.qrDetails.type == 'hotel'
              ? {
                  "name": nameController.text.trim(),
                  'hotelName': hotelNameController.text.trim(),
                  'hotelContactNumber': hotelContactController.text.trim(),
                  'contactNumber': contactNumberController.text.trim(),
                  "address": addressController.text.trim(),
                  "state": stateController.text.trim(),
                  "city": cityController.text.trim(),
                  "pincode": pinCodeController.text.trim(),
                }
              : {
                  "name": nameController.text.trim(),
                  'otherDetails': otherDetailsController.text.trim(),
                  'contactNumber': contactNumberController.text.trim(),
                  'carNumber': vehicleNumberController.text.trim(),
                };
      BlocProvider.of<UpdateQRDetailsBloc>(context).add(
        PerformUpdateQRDetailsEvent(
          id: widget.qrDetails.sId ?? 0,
          data: body,
        ),
      );
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

// Widget HomeData() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text("Name", style: AppStyles.textFieldText_15_w500),
//       SizedBox(
//         height: 15.h,
//       ),
//       CustomTextField(
//         autoFocus: false,
//         focusNode: nameFocusNode,
//         textCapitalize: TextCapitalization.words,
//         errorMessage: nameValidate == true ? CommonMessage.enterName : '',
//         isValidate: nameValidate,
//         onChange: (data) {
//           if (data.toString().isEmpty) {
//             setState(() {
//               nameValidate = true;
//               emptynameValidate = true;
//             });
//           } else {}
//         },
//         hintText: "",
//         isPasswordField: false,
//         textFieldController: nameController,
//         keyboardType: TextInputType.name,
//       ),
//       Text("Contact Number", style: AppStyles.textFieldText_15_w500),
//       SizedBox(
//         height: 15.h,
//       ),
//       CustomTextField(
//         autoFocus: false,
//         focusNode: contactNumberFocusNode,
//         textCapitalize: TextCapitalization.words,
//         errorMessage: contactNumberValidate == true
//             ? emptyContactNumberValidate == true
//                 ? CommonMessage.enterContact
//                 : contactNumberPatternValidate == true
//                     ? CommonMessage.enterValidContact
//                     : "null"
//             : "null",
//         isValidate: contactNumberValidate,
//         onChange: (data) {
//           if (data.toString().isEmpty) {
//             setState(() {
//               contactNumberValidate = true;
//               emptyContactNumberValidate = true;
//             });
//           } else {
//             if (CommonRegExps.mobileRegExp.hasMatch(
//               data,
//             )) {
//               setState(() {
//                 contactNumberValidate = false;
//                 emptyContactNumberValidate = false;
//                 contactNumberPatternValidate = false;
//               });
//             } else {
//               setState(() {
//                 contactNumberValidate = true;
//                 emptyContactNumberValidate = false;
//                 contactNumberPatternValidate = true;
//               });
//             }
//           }
//         },
//         inputFormatter: [
//           FilteringTextInputFormatter.digitsOnly,
//           LengthLimitingTextInputFormatter(10),
//         ],
//         hintText: "",
//         textFieldController: contactNumberController,
//         isPasswordField: false,
//         keyboardType: TextInputType.number,
//       ),
//       Text("Add Member", style: AppStyles.textFieldText_15_w500),
//       SizedBox(
//         height: 15.h,
//       ),
//       CustomTextField(
//         autoFocus: false,
//         focusNode: addMemberFocusNode,
//         textCapitalize: TextCapitalization.words,
//         errorMessage: addMemberValidate == true ? CommonMessage.enterAddMember : '',
//         isValidate: addMemberValidate,
//         onChange: (data) {
//           if (data.toString().isEmpty) {
//             setState(() {
//               nameValidate = true;
//               emptyaddMemberValidate = true;
//             });
//           } else {}
//         },
//         hintText: "",
//         isPasswordField: false,
//         textFieldController: addMemberController,
//         keyboardType: TextInputType.name,
//       ),
//       SizedBox(
//         width: 330.w,
//         height: 40.h,
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             Navigator.pushNamed(
//               context,
//               AppScreens.firstTimeHomeScreen,
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppStyles.activeTabColor,
//             padding: EdgeInsets.symmetric(vertical: 11.h),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(11),
//             ),
//           ),
//           child: Text(
//             'Add Member',
//             style: AppStyles.white_15_w500.copyWith(fontSize: 13),
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 17.h,
//       ),
//       Text("Add Emergancy Number", style: AppStyles.textFieldText_15_w500),
//       SizedBox(
//         height: 15.h,
//       ),
//       CustomTextField(
//         autoFocus: false,
//         focusNode: addEmergancyNumberFocusNode,
//         textCapitalize: TextCapitalization.words,
//         errorMessage: addEmergancyNumberValidate == true ? CommonMessage.enterAddEmergancyNumber : '',
//         isValidate: addEmergancyNumberValidate,
//         onChange: (data) {
//           if (data.toString().isEmpty) {
//             setState(() {
//               addEmergancyNumberValidate = true;
//               emptyaddEmergancyNumberValidate = true;
//             });
//           } else {}
//         },
//         hintText: "",
//         isPasswordField: false,
//         textFieldController: addEmergancyNumberController,
//         keyboardType: TextInputType.name,
//       ),
//       Text("Address/House", style: AppStyles.textFieldText_15_w500),
//       SizedBox(
//         height: 15.h,
//       ),
//       CustomTextField(
//         autoFocus: false,
//         focusNode: addressHouseFocusNode,
//         textCapitalize: TextCapitalization.words,
//         errorMessage: addressHouseValidate == true ? CommonMessage.enterAddressHouse : '',
//         isValidate: addressHouseValidate,
//         onChange: (data) {
//           if (data.toString().isEmpty) {
//             setState(() {
//               addressHouseValidate = true;
//               emptyaddressHouseValidate = true;
//             });
//           } else {}
//         },
//         hintText: "",
//         isPasswordField: false,
//         textFieldController: addressHouseController,
//         keyboardType: TextInputType.name,
//       ),
//       Text("Address/Full", style: AppStyles.textFieldText_15_w500),
//       SizedBox(
//         height: 15.h,
//       ),
//       CustomTextField(
//         autoFocus: false,
//         focusNode: addressFocusNode,
//         textCapitalize: TextCapitalization.words,
//         errorMessage: addressValidate == true ? CommonMessage.enterAddressFull : '',
//         isValidate: addressValidate,
//         onChange: (data) {
//           if (data.toString().isEmpty) {
//             setState(() {
//               addressValidate = true;
//               emptyaddressValidate = true;
//             });
//           } else {}
//         },
//         hintText: "",
//         isPasswordField: false,
//         textFieldController: addressController,
//         keyboardType: TextInputType.name,
//       ),
//       SizedBox(
//         height: 10.h,
//       ),
//       SizedBox(
//         width: 300.w,
//         height: 55.h,
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             Navigator.pushNamed(
//               context,
//               AppScreens.homeScreen,
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppStyles.primary,
//             padding: EdgeInsets.symmetric(vertical: 16.h),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           ),
//           child: Text(
//             'Submit',
//             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
