import 'package:Digibells/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_styles.dart';

class LoaderWidget extends StatelessWidget {

  String? message;

  LoaderWidget({this.message});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Container(

            color: Colors.transparent,/* Colors.black12.withOpacity(0.20),*/
            child: Center(
                child: Card(
                  color: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(ImageAssetPath.loader,
                         width: 160.w,   fit: BoxFit.cover),
                      Visibility(visible: message != null, child: SizedBox(height: 5.0,)),
                      Visibility(
                        visible: message != null,
                        child: Text(
                          message ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.0,
                              color: AppStyles.black
                          ),
                        ),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }
}