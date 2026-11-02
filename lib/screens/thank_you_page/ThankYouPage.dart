import 'package:Digibells/constants/asset_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  ImageAssetPath.splashScreen, // Replace with your logo asset path
                  height: 55,
                  width: 120,
                ),
              ),
              SizedBox(height: 70.h),
              Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'For Using Digibells',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Download Digibells, Ring In The Future',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
Spacer(),
              Text(
                'Download App',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageAssetPath.playStore, // Replace with the Google Play button image path
                    height: 60.h,
                   width: 150.w,
                   // width: MediaQuery.of(context).size.width / 0.5,
                  ),
                  SizedBox(width: 10.w),
                  Image.asset(
                    ImageAssetPath.appStore, // Replace with the App Store button image path
                    height: 60.h,
                    width: 150.w,
                    fit: BoxFit.contain,
                   // width: MediaQuery.of(context).size.width / 0.5,

                  ),
                ],
              ),
              SizedBox(height: 200.h),
            ],
          ),
        ),
      ),
    );
  }
}