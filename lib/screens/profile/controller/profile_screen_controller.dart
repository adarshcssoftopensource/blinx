import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/profile/model/profile_screen_model.dart';
import 'package:blinx_mobile/screens/profile/services/profile_screen_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileService profileServiceService = ProfileService();

  // Reactive variable holding the full profile response data
  Rx<UserProfileResponse?> profileData = Rx<UserProfileResponse?>(null);

  var isLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  Future<void> getProfileApi() async {
    isLoading.value = true;
    {
      try {
        var response = await profileServiceService.getMyProfileService();
        if (response.success) {
          nameController.text = response.data?.data.user.name ?? '';
          emailController.text = response.data?.data.user.email ?? '';
          profileData.value = response.data;

          final image = response.data?.data.user.image ?? '';
          if (image.isNotEmpty) {
            AuthController.to.profileImage.value = image;
            await StoreServices.saveProfileImage(image);
          }
        } else {
          Get.snackbar("Failed", response.message);
        }
      } catch (e, stace) {
        Get.snackbar("Failed", e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> profileUpdateApi(dynamic postData) async {
    try {
      isLoading.value = true;

      final response = await profileServiceService.profileUpdateService(
        postData,
      );

      if (response.success && response.data != null) {
        await getProfileApi();

        final isProfileComplete =
            profileData.value?.data.user.isProfileComplete ?? false;
        AuthController.to.profileComplete.value = isProfileComplete;
        await StoreServices.saveProfileComplete(isProfileComplete);

        final updatedImage = profileData.value?.data.user.image ?? '';
        if (updatedImage.isNotEmpty) {
          await NetworkImage(updatedImage).evict();
          AuthController.to.profileImage.value = '';
          await Future.delayed(Duration(milliseconds: 100));
          AuthController.to.profileImage.value = updatedImage;
          await StoreServices.saveProfileImage(updatedImage);
        }

        Get.snackbar(
          "Success",
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Failed",
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stack) {
    } finally {
      isLoading.value = false;
    }
  }
}
