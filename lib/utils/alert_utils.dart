import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_screens/app_screens.dart';
import '../main.dart';
import 'app_styles.dart';

class AlertUtils {
  static void showAlertDialog(BuildContext context, String title, String message) {
    debugPrint("Display alert");
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(message),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK")),
              ],
            ));
  }

  static void showAutoCloseDialogue(BuildContext context, String message, int duration, String title) {
    showGeneralDialog(
      barrierLabel: "Label1",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(Duration(seconds: duration), () {
          Navigator.pop(context);
        });
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 20.0.h,
            child: SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.5.h), topRight: Radius.circular(2.5.h)),
                child: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.0.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child:
                            Text(title, textAlign: TextAlign.center, style: const TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            message,
                            style: const TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    ).then((value) => {debugPrint('Dialogue dismissed')});
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1);
  }

  static void showNotInternetDialogue(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Label1",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 30.0.h,
            child: SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.5.h), topRight: Radius.circular(2.5.h)),
                child: Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.0.h,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(0),
                        child: Text('No Internet!',
                            textAlign: TextAlign.center, style: TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Please check your internet connectivity',
                            style: TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    ).then((value) => {debugPrint('Dialogue dismissed')});
  }

  static void showManuallyCloseDialogue(BuildContext context, String message, int duration, String title) {
    showGeneralDialog(
      barrierLabel: "Label1",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150.h,
            child: SizedBox.expand(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(2.5.h), topRight: Radius.circular(2.5.h)),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    color: AppStyles.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 3.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.close)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(0),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            // style: AppStyles.fontStyleW700Bold.copyWith(color: AppStyles.textColor2, fontSize: 20.sp, letterSpacing: -0.5)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              message,
                              // style: AppStyles.fontStyleGrey.copyWith(fontWeight: FontWeight.w400, fontSize: 18.sp, letterSpacing: -0.1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    ).then((value) => {print('Dialogue dismissed')});
  }

  static void showBlockDilog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Alert!'),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text('Your account has been temporarily restricted. Please contact our support team for further assistance and information.'),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("Ok", style: TextStyle(color: Colors.blue))),
              ],
            ));
  }

  static void showGuestUserDialog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'Please Login!',
                style: TextStyle(fontSize: 16),
              ),
              content: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  'Login now to unlock all features and enjoy a seamless experience!',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      prefs?.clear();
                      Navigator.pushNamedAndRemoveUntil(context, AppScreens.loginScreen, (Route<dynamic> route) => false);
                    },
                    child: Text("Login", style: TextStyle(color: AppStyles.primary))),
              ],
            ));
  }

  static void reactiveAccount(BuildContext context, Function? sendOTP) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Alert!'),
              content: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text('Your account was deleted previously. Do you want to reactivate your account?'),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      sendOTP!();
                    },
                    child: Text("Reactive", style: TextStyle(color: Colors.blue))),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.red))),
              ],
            ));
  }
}
