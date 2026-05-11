// ─── Controller ───────────────────────────────────────────────────────────────

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../business_logic/store_services.dart';
import '../../../../utils/screens/network_utils.dart';
import '../../../../utils/screens/string_constants.dart';
import '../../controller/auth_controller.dart';

class SignInController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  final RxBool isSignInLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> validateAndLogin() async {
    emailError.value = '';
    passwordError.value = '';

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    bool isValid = true;

    if (email.isEmpty) {
      emailError.value = AppConstants.requiredEmail;
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = AppConstants.validEmailError;
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError.value = AppConstants.requiredPassword;
      isValid = false;
    } else if (password.length < 8) {
      passwordError.value = AppConstants.requiredPasswordInPattern;
      isValid = false;
    }

    if (!isValid) return;

    isSignInLoading.value = true;
    try {
      final fcmToken = await StoreServices.getFcmToken();
      print("FCM::::$fcmToken");

      await authController.loginApi({
        "email": email,
        "password": password,
      }, email: email);
    } catch (e) {
      Get.snackbar(
        AppConstants.loginFailed,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSignInLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    if (!await NetworkUtils.hasInternet()) {
      Get.snackbar(
        AppConstants.noInternet,
        AppConstants.checkInternet,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isGoogleLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        forceCodeForRefreshToken: true,
      );

      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        Get.snackbar(
          AppConstants.failed,
          AppConstants.unknownError,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final Map<String, dynamic> payload = {
        "provider": "google",
        "token": googleAuth.idToken!,
      };

      final bool isSuccess =
          await authController.socialLoginApiWithResult(payload) ?? false;

      if (!isSuccess) {
        Get.snackbar(
          AppConstants.loginFailed,
          AppConstants.tryAgain,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppConstants.loginFailed,
        AppConstants.somethingWentWrong,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
