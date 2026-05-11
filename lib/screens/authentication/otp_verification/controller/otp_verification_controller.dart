import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../utils/screens/string_constants.dart';
import '../../controller/auth_controller.dart';

class OtpVerificationController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  // 6 separate controllers for each OTP digit box
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  // 6 focus nodes to auto-move focus between OTP boxes
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final RxString otpError = ''.obs;

  @override
  void onClose() {
    for (var c in otpControllers) c.dispose();
    for (var n in focusNodes) n.dispose();
    super.onClose();
  }

  Future<bool> hasInternet() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) return false;
    return await InternetConnectionChecker().hasConnection;
  }

  void clearOtpFields() {
    for (var c in otpControllers) c.clear();
    for (var n in focusNodes) n.unfocus();

    otpError.value = '';

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNodes.first.requestFocus();
    });
  }

  Future<void> submitOtp(String email, bool isSignUpTrue) async {
    if (!await hasInternet()) {
      Get.snackbar(
        AppConstants.noInternet,
        AppConstants.checkInternet,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final String otp = otpControllers.map((e) => e.text).join();

    if (otp.length < 6) {
      otpError.value = AppConstants.completeOtpError;
      return;
    }

    otpError.value = '';
    clearOtpFields();

    if (isSignUpTrue) {
      authController.verifyOtpSignupApi(email, otp);
    } else {
      authController.verifyOtpApi(email, otp);
    }
  }
}
