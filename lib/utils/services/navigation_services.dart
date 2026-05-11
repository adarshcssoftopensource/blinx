import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();
  void goBack() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
    }
  }

  Future<void> navigateTo(Widget screen) async {
    await navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> pushAndReplace(Widget screen) async {
    await navigatorKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> clearAndNavigateTo(Widget screen) async {
    await navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }
}
