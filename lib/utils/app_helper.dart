import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppHelper {
  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }

  Future<dynamic> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    dynamic result = await showModalBottomSheet(
      elevation: 12,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Camera',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.of(context).pop(0);
                },
              ),
              const Divider(
                height: 0,
                color: Colors.black26,
                thickness: 0.5,
              ),
              ListTile(
                title: const Text(
                  'Gallery',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.of(context).pop(1);
                },
              ),
              const Divider(
                height: 0,
                color: Colors.black26,
                thickness: 0.5,
              ),
            ],
          ),
        );
      },
    );
    if (result != null && result is int) {
      if (result == 0) {
        try {
          final XFile? pickedFile = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 25,
          );
          if (pickedFile != null) {
            final bytes = pickedFile.readAsBytes();
            debugPrint('SIZE IN BYTE ===> $bytes');
            return File(pickedFile.path);
          }
        } catch (e) {
          debugPrint('Exception========> $e');
        }
      } else if (result == 1) {
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 25,
        );

        if (pickedFile != null) {
          final bytes = pickedFile.readAsBytes();

          debugPrint('SIZE IN BYTE ===> ${bytes.toString()}');
          return File(pickedFile.path);
        }
      } else if (result == 2) {
        return null;
      }
    }
    return null;
  }
}
