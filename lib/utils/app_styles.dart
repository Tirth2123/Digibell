import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  // digibell_app
  // static const primary = Color(0xff408279);
  static const primary = Color(0xff408279);
  static const lightPrimary = Color(0xffEEF8F7);

  static const whiteColor = Colors.white;
  static const redColor = Color(0xFFBE2424);

  static const textFieldBorderColor = Color(0xffCECECE);
  static const textFieldText = Color(0xff212121);
  static const normalText = Color(0xff666666);
  static const white = Color(0xffFFFFFF);
  static const black = Color(0xff000000);
  static const switchColor = Color(0xffD7E2E1);
  static const greyColor = Color(0xff777777);
  static const secondaryPrimaryColor = Color(0xffB9CFCC);
  static const activeTabColor = Color(0xff7CA8A2);
  static const bordercolor = Color(0xffF1F1F1);
  static const navyblue = Color(0xff1D242C);
  static const hintText = Color(0xff666666);
  static const blue = Color(0xff032853);
  static const circle = Color(0xffDADEE4);
  static const red = Color(0xff990404);
  static const green = Color(0xff02BF4E);
  static const call_green = Color(0xff01B513);
  static const call_red = Color(0xffB50101);
  static const audio_call = Color(0xffD7E2E1);
  static const audio_call_text = Color(0xff045C50);
  static const dividerColor = Color(0xffEEEEEE);
  static const textColor = Color(0xff212121);
  static const grayColor = Color(0xff334247);
  static const boderColor = Color(0xb5e7e4e4);

  // Digibell TextStyle

  static TextStyle fontStyleW500Bold =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppStyles.textColor, decoration: TextDecoration.none, fontFamily: 'Montserrat');

  static TextStyle fontStyleW600Bold =
      TextStyle(fontSize: 14.sp, color: AppStyles.textColor, fontWeight: FontWeight.w600, decoration: TextDecoration.none, fontFamily: 'Montserrat');

  static TextStyle fontStyleInter = TextStyle(
    fontFamily: 'Montserrat',
    color: Colors.white,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle fontInter400 = TextStyle(
    fontFamily: 'Montserrat',
    color: Colors.white,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle white_24_w400 = TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w400, fontFamily: 'Montserrat', color: AppStyles.white);

  static TextStyle textFieldText_15_w500 =
      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, fontFamily: 'Montserrat', color: AppStyles.textFieldText);

  static TextStyle red_16_w300 = TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w300, fontFamily: 'Montserrat', color: Colors.red);

  static TextStyle black_24_w300 = TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500, fontFamily: 'Montserrat', color: AppStyles.black);

  static TextStyle white_15_w500 = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, fontFamily: 'Montserrat', color: AppStyles.white);

  static TextStyle navyblue_15_w400 = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, fontFamily: 'Montserrat', color: AppStyles.navyblue);

  static TextStyle greyColor_12_w500 = TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Montserrat', color: AppStyles.greyColor);

  static TextStyle black_17_w600 = TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, fontFamily: 'Montserrat', color: AppStyles.black);

  static TextStyle white_16_w700 = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, fontFamily: 'Montserrat', color: AppStyles.white);

  static TextStyle black_14_w500 = TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Montserrat', color: AppStyles.black);

  static TextStyle hintText_15_w400 = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, fontFamily: 'Montserrat', color: AppStyles.hintText);

  static TextStyle white_20_w600 = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, fontFamily: 'Montserrat', color: AppStyles.white);
}
