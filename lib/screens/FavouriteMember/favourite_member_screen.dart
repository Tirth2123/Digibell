import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app_screens/app_screens.dart';
import '../../constants/asset_path.dart';
import '../../utils/app_styles.dart';

class FavouriteMemberScreen extends StatefulWidget {
  const FavouriteMemberScreen({super.key});

  @override
  State<FavouriteMemberScreen> createState() => _FavouriteMemberScreenState();
}

class _FavouriteMemberScreenState extends State<FavouriteMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppStyles.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140.h,
              color: AppStyles.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppStyles.white,
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Favourite Member",
                            textAlign: TextAlign.center,
                            style: AppStyles.white_24_w400.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 705.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 40.h, left: 25.w, right: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Text(
                      "Favourites",
                      style: AppStyles.black_17_w600,
                    ),

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: 15.h,
                            ),
                            child: Container(
                              height: 80.h,
                              width: 345.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(color: AppStyles.textFieldBorderColor),
                              ),
                              child: ListTile(
                                // contentPadding: EdgeInsets.zero,
                                leading: Image.asset(ImageAssetPath.memberImage),
                                trailing: Icon(
                                  Icons.add,
                                  color: AppStyles.black,
                                ),
                                title: Text(
                                  "Mark Ross",
                                  style: AppStyles.black_17_w600,
                                ),
                                subtitle: Text(
                                  "markross@gmail.com",
                                  style: TextStyle(color: AppStyles.hintText),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              // color: AppStyles.white,
            ),
          ],
        ),
      ),);
  }
}
