import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/onboarding/view/onboarding_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ───────────────── Splash Controller ─────────────────

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _goToNextScreen();
  }

  Future<void> _goToNextScreen() async {
    String? token = await StoreServices.getAccessToken();
    bool? isSteward = await StoreServices.getStewardStatus();
    String? savedImage = await StoreServices.getProfileImage();

    debugPrint('isSteward: $isSteward');
    debugPrint('token: $token');
    debugPrint('SPLASH IMAGE: $savedImage');

    if (savedImage != null && savedImage.isNotEmpty) {
      AuthController.to.profileImage.value = savedImage;
    }

    await Future.delayed(const Duration(seconds: 2));

    if (token != null && token.isNotEmpty) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }
}
