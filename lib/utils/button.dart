// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// class CustomSubmitButton extends StatefulWidget {
//   final String text;
//   final VoidCallback? onTap;
//   final double? height;
//   final double? width;
//   final double? fontSize;
//   final bool? isOutlinedButton;
//
//   const CustomSubmitButton({
//     super.key,
//     required this.text,
//     required this.onTap,
//     this.height,
//     this.width,
//     this.fontSize,
//     this.isOutlinedButton,
//   });
//
//   @override
//   State<CustomSubmitButton> createState() => _CustomSubmitButtonState();
// }
//
// class _CustomSubmitButtonState extends State<CustomSubmitButton> {
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center,
//       child: SizedBox(
//         height: widget.height ?? 5.5.h,
//         width: widget.width ?? 50.w,
//         child: ElevatedButton(
//           style: ButtonStyle(
//             shape: WidgetStateProperty.all(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             backgroundColor: WidgetStateProperty.all(
//               widget.isOutlinedButton == true
//                   ? CustomColor.white
//                   : CustomColor.primary,
//             ),
//             side: WidgetStateProperty.all(
//               widget.isOutlinedButton == true
//                   ? const BorderSide(color: CustomColor.primary, width: 1)
//                   : BorderSide.none,
//             ),
//           ),
//           onPressed: widget.onTap,
//           child: Text(
//             widget.text,
//             style: GoogleFonts.inter(
//               fontSize: widget.fontSize ?? 13.sp,
//               fontWeight: FontWeight.w600,
//               color: widget.isOutlinedButton == true
//                   ? CustomColor.primary
//                   : Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'app_styles.dart';

class AppButton extends StatelessWidget {
  final String? buttonName;
  final Function()? onPress;
  final bool? isVisible;
  final double? height;
  final double? width;
  final Color? color;

  AppButton({this.buttonName, this.onPress, this.isVisible, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isVisible == null || isVisible == true) {
          onPress!();
        }
      },
      child: Container(
        height: height ?? 50.0,
        width: width,
        decoration: ShapeDecoration(
          color: isVisible == null || isVisible == true ? color ?? AppStyles.primary : AppStyles.primary.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Center(
          child: Text(
            buttonName ?? '',
            // style: AppStyles.fontStyleW600.copyWith(fontSize:16.sp, color: AppStyles.whiteColor),
          ),
        ),
      ),
    );
  }
}

class AppMacroPoloButton extends StatelessWidget {
  final String? buttonName;
  final Function()? onPress;
  final bool? isVisible;
  final double? height;
  final double? width;
  final Color? color;

  AppMacroPoloButton({this.buttonName, this.onPress, this.isVisible, this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isVisible == null || isVisible == true) {
          onPress!();
        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          // color: AppStyles.appColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //     ImageAssetPath.icWTVideoCall
            // ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              buttonName ?? '',
              // style: AppStyles.fontInter500.copyWith(
              //   fontSize: 16.sp,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}