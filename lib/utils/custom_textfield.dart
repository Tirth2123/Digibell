
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_styles.dart';
import 'border.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPasswordField;
  final bool secureText;
  final TextInputType keyboardType;
  final String? label;
  final bool? readOnly;
  final OnData? onChange;
  final OnData? onSubmitted;
  final int? maxLength;
  final bool? prefilled;
  final VoidCallback? onTap;
  final String? errorMessage;
  final bool? isValidate;
  final bool? autoFocus;
  final TextEditingController? textFieldController;
  final bool isLargeTextField;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatter;
  final bool? showPrefix;
  final bool? enableSuggestions;
  final bool? isSearchField;
  final bool? calendarToday;
  final bool? getStudent;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final TextCapitalization? textCapitalize;
  final bool? color;

  const CustomTextField(
      {super.key,
      required this.hintText,
        this.inputFormatters,

        required this.isPasswordField,
      this.secureText = false,
      required this.keyboardType,
      this.textCapitalize,
      this.prefilled,
      this.label,
      this.readOnly,
      this.textFieldController,
      this.textInputAction = TextInputAction.go,
      this.maxLength,
      this.onChange,
      this.onSubmitted,
      this.autoFocus,
      this.validator,
      this.errorMessage,
      this.isValidate,
      this.onTap,
      this.focusNode,
      this.isLargeTextField = false,
      this.inputFormatter,
      this.showPrefix,
      this.enableSuggestions = false,
      this.isSearchField,
      this.calendarToday,
      this.getStudent,
      this.width,
      this.color});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widget.width,
        height:  widget.isLargeTextField == true ? 100.h : 75,
      child: TextFormField(
        maxLength: widget.maxLength,
        autocorrect: false,
        maxLines: widget.isLargeTextField ? 4 : 1,
        minLines: widget.isLargeTextField ? 4 : 1,

        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
        textCapitalization: widget.textCapitalize ?? TextCapitalization.none,
        autofocus: widget.autoFocus ?? false,
        focusNode: widget.focusNode,
        validator: widget.validator,
        controller: widget.textFieldController,
        expands: false,
        readOnly: widget.readOnly ?? false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTapOutside: (event) {
          widget.focusNode?.unfocus();
        },
        cursorColor: AppStyles.textFieldBorderColor,
        toolbarOptions: widget.secureText == true
            ? const ToolbarOptions(
                copy: false,
                cut: false,
                paste: false,
              )
            : null,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatter,
        textInputAction: widget.textInputAction,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onChanged: widget.onChange,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        style: AppStyles.navyblue_15_w400,
        decoration: InputDecoration(
          errorStyle: AppStyles.red_16_w300,

          counterText: '',
          // isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 18.h,
          ),

          hintText: widget.hintText,
          hintStyle: AppStyles.textFieldText_15_w500,
          fillColor: AppStyles.white,
          filled: true,
          helperMaxLines: 1,
         // errorText: widget.isValidate == true ? widget.errorMessage : null,
          border: CommonBorders().textFieldBorder,
          disabledBorder: CommonBorders().textFieldBorder,
          enabledBorder: CommonBorders().textFieldBorder,
          focusedBorder: CommonBorders().textFieldBorder,
          errorMaxLines: 3,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(
              color: widget.isValidate == true ? Colors.red : AppStyles.textFieldBorderColor,
              width: 1.sp,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(
              color: widget.isValidate == true ? AppStyles.textFieldBorderColor : AppStyles.textFieldBorderColor,
              width: 1.sp,
            ),
          ),
          suffixIcon: widget.calendarToday == true
        ? const Padding(
        padding: EdgeInsets.only(left: 2),
        child: Icon(
          Icons.calendar_today,
          color: Colors.black45,
          size: 20,
        ),
      )
              : widget.isSearchField == true
              ? Padding(
              padding: EdgeInsets.only(
                  left: 2.w, right: 2.w, top: 1.5.h, bottom: 1.5.h),
              child: Icon(
                Icons.search_sharp,
                color: Colors.black45,
                size: 20,
              ),
          ):

          null
        ),
      ),
    );
  }
}

typedef OnData<T> = void Function(T data);
