import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
          (Route<dynamic> route) => false,
    );
  }

  void setupLocator() {
    locator.registerLazySingleton(() => NavigationService());
  }

  void showMyDialog() {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => Center(
          child: Material(
            color: Colors.transparent,
            child: Text('Hello'),
          ),
        ));
  }
}
