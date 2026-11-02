import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/asset_path.dart';
import '../utils/app_styles.dart';
import '../utils/button.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.minHeight),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 200.h),
                    Image.asset(
                      ImageAssetPath.imNoInternet,
                      width: 226.w,
                      height: 203.h,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'Ooops!',
                      style: AppStyles.fontStyleW500Bold.copyWith(fontSize: 34.sp, color: AppStyles.grayColor),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'No internet connection,\ncheck your internet settings.',
                      textAlign: TextAlign.center,
                      style: AppStyles.fontStyleW500Bold.copyWith(fontSize: 16.sp, color: AppStyles.grayColor),
                    ),
                    SizedBox(height: 122.h),
                    AppButton(
                      buttonName: 'Try Again',
                      onPress: () {},
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
