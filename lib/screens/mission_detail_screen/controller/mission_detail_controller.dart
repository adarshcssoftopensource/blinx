import 'package:blinx_mobile/screens/submit_proof_screen/view/submit_proof.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../business_logic/store_services.dart';
import '../model/mission_detail_model.dart';
import '../services/mission_detail_services.dart';

class MissionDetailController extends GetxController {
  final MissionDetailServices _services = MissionDetailServices();

  var missionDetail = Rxn<MissionDetailModel>();
  var isLoading = false.obs;

  // Tracks claim API loading state separately to avoid blocking the UI
  var isClaiming = false.obs;

  // Stores applicationId returned after successful claim — useful for submit proof screen
  var claimedApplicationId = ''.obs;

  Future<void> fetchMissionDetail(String missionId) async {
    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null) return;

      final response = await _services.getMissionDetail(
        token: token,
        missionId: missionId,
      );

      if (response['data']['status'] == true) {
        missionDetail.value = MissionDetailModel.fromJson(response);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // Calls claim API — POST /mobile/missions/{id}/claim
  Future<void> claimMission(String missionId) async {
    if (isClaiming.value) return;

    try {
      isClaiming.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null) return;

      final response = await _services.claimMission(
        token: token,
        missionId: missionId,
      );

      // Success case: status == true
      if (response['status'] == true) {
        claimedApplicationId.value =
            response['data']['applicationId']?.toString() ?? '';

        // Navigate to SubmitProofScreen passing both applicationId and missionId
        Get.to(
          () => SubmitProofScreen(
            applicationId: claimedApplicationId.value,
            missionId: missionId,
          ),
          transition: Transition.rightToLeft,
        );

        // Error case: statusCode present (e.g. 400, 401, 500)
      } else {
        final message =
            response['message']?.toString() ?? "Something went wrong";

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
      isClaiming.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
