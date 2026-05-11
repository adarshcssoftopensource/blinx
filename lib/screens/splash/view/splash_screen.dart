import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

// ───────────────── Splash Screen ─────────────────

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            ImageConstants.blinxLogo,
            width: 180,
            height: 85,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
