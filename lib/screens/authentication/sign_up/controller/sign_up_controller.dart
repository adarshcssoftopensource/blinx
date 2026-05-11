import 'dart:io';

import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/authentication/otp_verification/view/otp_verification_screen.dart';
import 'package:blinx_mobile/utils/screens/network_utils.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  final AuthController authController = Get.put(
    AuthController(),
    permanent: true,
  );

  // Image file
  final Rx<File?> imageFile = Rx<File?>(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString nameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  final RxBool isSignUpLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool isStrongPassword(String password) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  bool validateFields() {
    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = AppConstants.requiredName;
      valid = false;
    } else {
      nameError.value = '';
    }

    if (emailController.text.trim().isEmpty) {
      emailError.value = AppConstants.requiredEmail;
      valid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = AppConstants.validEmailError;
      valid = false;
    } else {
      emailError.value = '';
    }

    if (passwordController.text.trim().isEmpty) {
      passwordError.value = AppConstants.requiredPassword;
      valid = false;
    } else if (!isStrongPassword(passwordController.text.trim())) {
      passwordError.value = AppConstants.passwordStrengthError;
      valid = false;
    } else {
      passwordError.value = '';
    }

    return valid;
  }

  Future<void> signUpWithGoogle() async {
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
          AppConstants.notice,
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
        await FirebaseAuth.instance.signOut();
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

  Future<void> signUp(BuildContext context) async {
    if (!validateFields()) return;

    final Map<String, dynamic> data = {
      "email": emailController.text.trim(),
      "name": nameController.text.trim(),
      "password": passwordController.text.trim(),
    };

    final file = imageFile.value;
    if (file != null && file.path.isNotEmpty) {
      data["profileImage"] = await dio.MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
    }

    final formData = dio.FormData.fromMap(data);

    isSignUpLoading.value = true;
    try {
      final result = await authController.signUpApi(
        formData,
        email: emailController.text.trim(),
      );

      if ((result["message"] ?? "").toString().toLowerCase().contains("wait")) {
        Get.snackbar(
          AppConstants.pleaseWait,
          result["message"],
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (result["otpSent"] == true) {
        Get.to(
          () => OtpVerificationScreen(
            email: emailController.text.trim(),
            isSignUpTrue: true,
          ),
        );
        return;
      }

      Get.snackbar(
        AppConstants.failed,
        result["message"] ?? AppConstants.somethingWentWrong,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSignUpLoading.value = false;
    }
  }
}
