import 'package:blinx_mobile/social_pulse_screen/report_successfully_screen/view/report_successfully.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';
import '../model/report_model.dart';
import '../services/report_services.dart';

class ReportController extends GetxController {
  final ReportServices _services = ReportServices();

  final isSubmitting = false.obs;
  final selectedReasons = <String>[].obs;
  final textController = TextEditingController();

  late String blinkId;

  final List<String> options = [
    AppConstants.safetyConcern,
    AppConstants.spam,
    AppConstants.offTopic,
    AppConstants.privacyViolation,
  ];

  void toggleReason(String reason) {
    if (selectedReasons.contains(reason)) {
      selectedReasons.remove(reason);
    } else {
      selectedReasons.add(reason);
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> reportBlink({required String description}) async {
    if (isSubmitting.value) return;

    if (selectedReasons.isEmpty) {
      Get.snackbar(
        "Validation",
        "Please select at least one reason",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final String reason = selectedReasons.join(', ');
      final String desc = description.isEmpty
          ? ' '
          : description.substring(
              0,
              description.length > 200 ? 200 : description.length,
            );

      final response = await _services.reportBlink(
        blinkId: blinkId,
        reason: reason,
        description: desc,
      );

      if (response.success && response.data != null) {
        final model = ReportModel.fromJson(response.data);
        print("Report Model: status=${model.status} | msg=${model.message}");

        Get.back();

        Future.delayed(const Duration(milliseconds: 300), () {
          showDialog(
            context: Get.context!,
            barrierDismissible: true,
            builder: (context) => const Center(
              child: Material(
                color: Colors.transparent,
                child: ReportSuccessScreen(),
              ),
            ),
          );
        });
      } else {
        Get.snackbar(
          "Failed",
          response.message ?? "Failed to report blink",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e, stack) {
      print("Report Error: $e");
      print("Report StackTrace: $stack");
    } finally {
      isSubmitting.value = false;
    }
  }
}
