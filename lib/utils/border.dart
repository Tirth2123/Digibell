
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_styles.dart';


class CommonBorders {
  OutlineInputBorder textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(11),
    borderSide: BorderSide(
      color: AppStyles.textFieldBorderColor,
      width: 1.5.sp,


    ),
  );
}

class ServicesCommonBorders {
  OutlineInputBorder servicesTextFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 1.sp,
    ),
  );
}