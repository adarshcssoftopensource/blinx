import 'package:blinx_mobile/screens/view_submit_screen/controller/view_submit_controller.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── ViewSubmit Controller ────────────────

class ViewSubmitScreenController extends GetxController {
  final String missionId;

  ViewSubmitScreenController({required this.missionId});

  late final ViewSubmitController controller;

  @override
  void onInit() {
    super.onInit();

    controller = Get.put(ViewSubmitController());

    controller.fetchViewSubmit(missionId);
  }

  @override
  void onClose() {
    Get.delete<ViewSubmitController>();

    super.onClose();
  }

  Map<String, dynamic> statusStyle(String s) {
    Color bg;

    String text;

    if (s == AppConstants.statusApproved) {
      bg = Colors.green;

      text = AppConstants.statusApprovedText;
    } else if (s == AppConstants.statusRejected) {
      bg = Colors.red;

      text = AppConstants.statusRejectedText;
    } else {
      bg = Colors.orange;

      text = AppConstants.statusPendingText;
    }

    return {'bg': bg, 'text': text};
  }
}
