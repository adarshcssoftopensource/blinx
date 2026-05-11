import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mission_activity_controller.dart';

class MissionActivityScreenController extends GetxController {
  final String missionId;

  MissionActivityScreenController({required this.missionId});

  late final MissionActivityController activityController;

  @override
  void onInit() {
    super.onInit();

    activityController = Get.put(MissionActivityController());

    activityController.fetchMissionActivity(missionId);

    debugPrint("MissionActivity — missionId: $missionId");
  }

  @override
  void onClose() {
    Get.delete<MissionActivityController>();

    super.onClose();
  }

  // Maps event type to asset icon

  String? assetIconForType(String type) {
    switch (type) {
      case AppConstants.eventTypeProofSubmitted:
        return CommonUi.setPngIcon("internal");

      case AppConstants.eventTypeUnderReview:
        return CommonUi.setPngIcon("star");

      case AppConstants.eventTypeClaimed:
      case AppConstants.eventTypeCreditApproved:
        return CommonUi.setPngIcon("circular");

      default:
        return null;
    }
  }

  // Maps event type to display title

  String titleForType(String type) {
    switch (type) {
      case AppConstants.eventTypeClaimed:
        return AppConstants.titleMissionClaimed;

      case AppConstants.eventTypeProofSubmitted:
        return AppConstants.titleProofSubmitted;

      case AppConstants.eventTypeUnderReview:
        return AppConstants.titleUnderReview;

      case AppConstants.eventTypeCreditApproved:
        return AppConstants.titleCreditApproved;

      default:
        return type;
    }
  }

  // Formats ISO timestamp to relative time string

  String formatTime(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime).toLocal();

      final diff = DateTime.now().difference(dt);

      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';

      if (diff.inHours < 24) return '${diff.inHours} hrs ago';

      return '${diff.inDays} days ago';
    } catch (_) {
      return '';
    }
  }
}
