import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
