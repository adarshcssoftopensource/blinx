import 'dart:convert';

import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/services/auth_services.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/utils/screens/snackbar_helper.dart';
import 'package:get/get.dart';

import '../../../steward_screen/marketplace_list/view/marketplace_list_screen.dart';
import '../reset_password/view/reset_password_screen.dart';

// GetX controller managing all authentication API calls and state
class AuthController extends GetxController {
  // Global singleton accessor — use AuthController.to anywhere in the app
  static AuthController get to => Get.find<AuthController>();

  // Service layer instance that handles raw HTTP auth API calls
  final AuthServices registerServices = AuthServices();

  // Reactive loading flag — drives loader UI across all auth screens
  var isLoading = false.obs;

  // Reactive profile image URL — updated after login/sign_up/social login
  RxString profileImage = ''.obs;
  RxString userName = ''.obs;

  //DEV FLAG - QA testing only (toggle true/false to test gating)
  var profileComplete = true.obs;

  // ADD-ON FOR EDIT PROFILE IMAGE
  @override
  void onInit() {
    super.onInit();
    _loadProfileImage();
    _loadProfileComplete();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await StoreServices.getUserName() ?? '';

    userName.value = name;
  }

  Future<void> _loadProfileImage() async {
    final image = await StoreServices.getProfileImage() ?? '';

    profileImage.value = image;
  }

  Future<void> _loadProfileComplete() async {
    final isComplete = await StoreServices.getProfileComplete();
    profileComplete.value = isComplete;
  }

  // Calls login API, saves tokens/user data, and routes to correct home screen
  Future<void> loginApi(
    Map<String, dynamic> postData, {
    required String email,
  }) async {
    try {
      isLoading.value = true;

      final response = await registerServices.loginApiService(postData);

      if (response.success && response.data != null) {
        await StoreServices.clearAllData();

        final data = response.data!;

        final String accessToken = data['access_token']?.toString() ?? '';
        final String refreshToken = data['refresh_token']?.toString() ?? '';
        final bool isSteward = data['isSteward'] == true;

        final String userId = _decodeUserIdFromToken(accessToken);
        await StoreServices.saveUserId(userId);

        // Persist tokens and steward role to local storage
        await StoreServices.saveAccessToken(accessToken);
        await StoreServices.saveRefreshToken(refreshToken);
        await StoreServices.saveStewardStatus(isSteward);

        // Save profile image and update reactive state
        final String image = data['profileImage']?.toString() ?? '';
        profileImage.value = image;
        await StoreServices.saveProfileImage(image);

        // Save user display name
        final String name = data['name']?.toString() ?? '';
        await StoreServices.saveUserName(name);
        userName.value = name;

        // Update profile completion flag from API response
        profileComplete.value = data['isProfileComplete'] == true;

        if (isSteward) {
          Get.offAll(() => MarketplaceListScreen());
        } else {
          Get.offAll(() => HomeScreen());
        }

        // Show API error message on login failure
        AppSnackbar.show(
          title: "Success",
          message: "Log in Successfully",
          isSuccess: true,
        );
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Login failed",
          isSuccess: false,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Failed",
        message: "Something went wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Calls sign_up API with image data, returns result map including otpSent flag
  Future<Map<String, dynamic>> signUpApi(
    dynamic postData, {
    required String email,
  }) async {
    try {
      isLoading.value = true;

      final response = await registerServices.signUpApiServiceWithImage(
        postData,
      );

      // Build result map; otpSent is true if success OR if account is inactive (OTP still needed)
      final Map<String, dynamic> result = {
        "success": response.success ?? false,
        "message": response.message ?? "",
        "otpSent":
            response.success == true ||
            (response.message != null &&
                response.message!.toLowerCase().contains("inactive")),
      };
      return result;
    } catch (e) {
      return {
        "success": false,
        "message": "Something went wrong",
        "otpSent": false,
      };
    } finally {
      isLoading.value = false;
    }
  }

  // Handles social login (Google/Apple), saves session data and routes to home
  Future<bool> socialLoginApiWithResult(Map<dynamic, dynamic> postData) async {
    try {
      isLoading.value = true;

      final response = await registerServices.socialLoginApiService(postData);

      if (response.success && response.data != null) {
        final data = response.data!['data'] ?? response.data!;

        // Save access and refresh tokens from social login response
        await StoreServices.saveAccessToken(
          data['access_token']?.toString() ?? '',
        );
        await StoreServices.saveRefreshToken(
          data['refresh_token']?.toString() ?? '',
        );

        final bool isSteward = data['isSteward'] == true;
        await StoreServices.saveStewardStatus(isSteward);

        if (data['profileImage'] != null &&
            data['profileImage'].toString().isNotEmpty) {
          profileImage.value = data['profileImage'];
          await StoreServices.saveProfileImage(data['profileImage']);
        }

        if (data['name'] != null && data['name'].toString().isNotEmpty) {
          await StoreServices.saveUserName(data['name']);
          userName.value = data['name'];
        }

        profileComplete.value = data['isProfileComplete'] == true;

        final savedToken = await StoreServices.getAccessToken();

        if (isSteward) {
          Get.offAll(() => MarketplaceListScreen());
        } else {
          Get.offAll(() => HomeScreen());
        }

        return true;
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Social login failed",
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Sends forgot password request — returns true if OTP email was dispatched
  Future<bool> forgotPasswordApi(String email) async {
    try {
      isLoading.value = true;

      final postData = {"email": email};

      final response = await registerServices.forgotPasswordApi(postData);

      if (response.success == true) {
        AppSnackbar.show(
          title: "Success",
          message: response.message ?? "Reset email sent successfully",
          isSuccess: true,
        );

        return true;
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Failed to send reset email",
          isSuccess: false,
        );

        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Failed",
        message: e.toString(),
        isSuccess: false,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Separate loading flag for OTP resend to avoid conflicting with main loader
  var isLoadingOTP = false.obs;

  // Resends OTP to the given email — returns true on success
  Future<bool> resendOTPApi(String email) async {
    try {
      isLoadingOTP.value = true;

      final postData = {"email": email};

      final response = await registerServices.resendOTPApi(postData);

      if (response.success == true) {
        AppSnackbar.show(
          title: "Success",
          message: response.message ?? "OTP sent successfully",
          isSuccess: true,
        );

        return true;
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Failed to send resend Email",
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Failed",
        message: e.toString(),
        isSuccess: false,
      );
      return false;
    } finally {
      isLoadingOTP.value = false;
    }
  }

  // Verifies OTP for forgot password flow — navigates to ResetPasswordScreen on success
  Future<void> verifyOtpApi(String email, String otp) async {
    try {
      isLoading.value = true;

      final postData = {"email": email, "otp": otp};

      final response = await registerServices.verifyOtpApi(postData);
      if (response.success == true) {
        AppSnackbar.show(
          title: "Success",
          message: response.message ?? "OTP verified successfully",
          isSuccess: true,
        );

        Get.to(() => ResetPasswordScreen(email: email));
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Invalid OTP",
          isSuccess: false,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Failed",
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verifies OTP for sign_up flow — saves session data and routes to home on success
  Future<void> verifyOtpSignupApi(String email, String otp) async {
    try {
      isLoading.value = true;

      final postData = {"email": email, "otp": otp};
      final response = await registerServices.verifyOtpSignUpApi(postData);

      if (response.success == true) {
        final data = response.data ?? {};

        // Save all session tokens and user info after successful sign_up OTP
        await StoreServices.saveAccessToken(
          data['access_token']?.toString() ?? '',
        );

        final String image = data['profileImage']?.toString() ?? '';
        profileImage.value = image;
        await StoreServices.saveProfileImage(image);

        await StoreServices.saveUserName(data['name']?.toString() ?? '');
        userName.value = data['name']?.toString() ?? '';

        await StoreServices.saveRefreshToken(
          data['refresh_token']?.toString() ?? '',
        );

        await StoreServices.saveStewardStatus(data['isSteward'] == true);

        // Route to steward or regular marketplace based on role
        if (data['isSteward'] == true) {
          Get.offAll(() => MarketplaceListScreen());
        } else {
          Get.offAll(() => HomeScreen());
        }

        Future.delayed(const Duration(milliseconds: 300), () {
          AppSnackbar.show(
            title: "Success",
            message: "Register Successfully",
            isSuccess: true,
          );
        });
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Invalid OTP",
          isSuccess: false,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Failed",
        message: "Something went wrong",
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Calls reset password API with new password — returns true on success
  Future<bool> resetPasswordApi(String email, String newPassword) async {
    try {
      isLoading.value = true;

      final postData = {"email": email, "newPassword": newPassword};

      final response = await registerServices.resetPasswordApi(postData);

      if (response.success == true) {
        AppSnackbar.show(
          title: "Success",
          message: response.message ?? "Password reset successfully",
          isSuccess: true,
        );
        return true;
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response.message ?? "Failed to reset password",
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Failed",
        message: e.toString(),
        isSuccess: false,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
    //   }
    // }
  }

  // JWT
  String _decodeUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';

      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> json = jsonDecode(decoded);
      return json['sub']?.toString() ?? '';
    } catch (e) {
      return '';
    }
  }
}
