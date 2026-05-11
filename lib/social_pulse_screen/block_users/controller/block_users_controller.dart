import 'package:blinx_mobile/social_pulse_screen/block_users/model/block_users_model.dart';
import 'package:blinx_mobile/social_pulse_screen/block_users/services/block_users_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockUsersController extends GetxController {
  final BlockUsersService _service = BlockUsersService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final blockedUsers = <BlockedUserModel>[].obs;
  final unblockingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlockedUsers();
  }

  Future<void> fetchBlockedUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getBlockedUsers();

      if (response.success && response.data != null) {
        final List raw = response.data['data']['users'] ?? [];
        blockedUsers.value = raw
            .map((e) => BlockedUserModel.fromJson(e))
            .toList();
      } else {
        errorMessage.value = response.message ?? "Failed to load";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      unblockingId.value = userId;

      final response = await _service.unblockUser(userId: userId);

      if (response.success) {
        blockedUsers.removeWhere((u) => u.id == userId);
        Get.snackbar(
          "Unblocked",
          response.message ?? "User unblocked successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Failed",
          response.message ?? "Failed to unblock",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
    } finally {
      unblockingId.value = '';
    }
  }
}
