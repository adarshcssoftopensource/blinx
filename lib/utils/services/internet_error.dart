import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNoInternetError() {
  Get.snackbar(
    "No Internet Connection",
    "Please Check Your Internet And Try Again",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade600,
    colorText: Colors.white,
    margin: const EdgeInsets.all(12),
    duration: const Duration(seconds: 3),
  );
}
