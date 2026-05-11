import 'dart:io';

import 'package:blinx_mobile/screens/mission_activity_screen/view/mission_activity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../business_logic/store_services.dart';
import '../model/submit_proof_model.dart';
import '../services/submit_proof_services.dart';

class SubmitProofController extends GetxController {
  final SubmitProofServices _services = SubmitProofServices();

  var isSubmitting = false.obs;
  var submissionResult = Rxn<SubmitProofModel>();

  // Calls submit-proof API with missionId, notes, and photos list
  Future<void> submitProof({
    required String missionId,
    required String notes,
    required List<File> photos,
  }) async {
    if (isSubmitting.value) return;

    try {
      isSubmitting.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null) return;

      final response = await _services.submitProof(
        token: token,
        missionId: missionId,
        notes: notes,
        photos: photos,
      );

      if (response['data']?['status'] == true) {
        submissionResult.value = SubmitProofModel.fromJson(response);

        Get.snackbar(
          "Success",
          response['data']['message'] ?? "Proof submitted for review",
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        // Navigate to MissionActivity passing missionId for activity API
        Get.to(
          () => MissionActivity(missionId: missionId),
          transition: Transition.rightToLeft,
        );
      } else {
        final message =
            response['message']?.toString() ?? "Failed to submit proof";

        Get.snackbar(
          "Failed",
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFE53935),
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(12),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
