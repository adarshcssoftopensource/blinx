import 'package:get/get.dart';

import '../../authentication/controller/auth_controller.dart';
import 'mission_detail_controller.dart';

class MissionDetailScreenController extends GetxController {
  final String missionId;

  MissionDetailScreenController({required this.missionId});

  final AuthController authController = Get.find<AuthController>();

  late final MissionDetailController missionController;

  @override
  void onInit() {
    super.onInit();

    missionController = Get.put(MissionDetailController());

    missionController.fetchMissionDetail(missionId);

    print("profileComplete = ${authController.profileComplete.value}");
  }

  @override
  void onClose() {
    Get.delete<MissionDetailController>();

    super.onClose();
  }
}
