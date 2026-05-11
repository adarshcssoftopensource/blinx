import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/string_constants.dart';
import '../../controller/auth_controller.dart';
import '../../otp_verification/view/otp_verification_screen.dart';

// ─── Controller ───────────────────────────────────────────────────────────────

class ForgotPasswordController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();

  final RxString errorText = ''.obs;

  final _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final email = emailController.text.trim();

    errorText.value = '';

    if (email.isEmpty) {
      errorText.value = AppConstants.requiredEmail;
      return;
    }

    if (!_emailRegex.hasMatch(email)) {
      errorText.value = AppConstants.validEmailError;
      return;
    }

    final bool success = await authController.forgotPasswordApi(email);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpVerificationScreen(email: email)),
      );
    }
  }
}
