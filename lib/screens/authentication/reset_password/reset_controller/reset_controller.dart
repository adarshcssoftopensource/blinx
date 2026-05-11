import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class ResetPasswordController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxString newPasswordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;

  final RegExp strongPasswordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> resetPassword(String email) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    newPasswordError.value = '';
    confirmPasswordError.value = '';

    bool hasError = false;

    if (newPassword.isEmpty) {
      newPasswordError.value = "Please enter new password";
      hasError = true;
    } else if (!strongPasswordRegex.hasMatch(newPassword)) {
      newPasswordError.value =
          "Password must be at least 8 characters and include uppercase, lowercase, number & special character";
      hasError = true;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Please confirm your password";
      hasError = true;
    } else if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      confirmPasswordError.value = "Passwords do not match";
      hasError = true;
    }

    if (hasError) return;

    final bool success = await authController.resetPasswordApi(
      email,
      newPassword,
    );

    if (success) {
      Get.offAllNamed("/sign-in");
    }
  }
}
