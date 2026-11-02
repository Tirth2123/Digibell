import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'app_styles.dart';

class CustomTextWithSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? subtitleBold;
  final bool showSubtitleBold;
  final bool isCrossCenter;

  const CustomTextWithSubtitle({
    Key? key,
    required this.title,
    required this.subtitle,
    this.subtitleBold,
    this.showSubtitleBold = false,
    this.isCrossCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCrossCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // style: AppStyles.fontStyleW700Bold.copyWith(color: AppStyles.textColor2, fontSize: 20.sp, letterSpacing: -0.5),
        ),
        SizedBox(height: 5.h),
        Text.rich(
          textAlign: isCrossCenter == true ? TextAlign.center : TextAlign.start,
          TextSpan(
            children: [
              TextSpan(
                text: subtitle,
                // style: AppStyles.fontStyleGrey.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.1),
              ),
              showSubtitleBold == true
                  ? TextSpan(
                text: subtitleBold ?? '',
                // style: AppStyles.fontStyleW700Bold.copyWith(letterSpacing: -0.1),
              )
                  : TextSpan(),
            ],
          ),
        ),
      ],
    );
  }
}
