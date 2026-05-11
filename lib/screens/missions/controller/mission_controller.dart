import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:get/get.dart';

import 'missions_screen_controller.dart';

class MissionsScreenStateController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final RxInt bottomNavIndex = (-1).obs;

  final List<String> filters = [
    AppConstants.filterAvailable,

    AppConstants.filterActive,

    AppConstants.filterSubmitted,

    AppConstants.filterCompleted,
  ];

  late final MissionsScreenController missionsController;

  @override
  void onInit() {
    super.onInit();

    missionsController = Get.put(MissionsScreenController());

    missionsController.fetchMissions(status: AppConstants.statusAvailable);
  }

  String getStatus(int index) {
    switch (index) {
      case 0:
        return AppConstants.statusAvailable;

      case 1:
        return AppConstants.statusActive;

      case 2:
        return AppConstants.statusSubmitted;

      case 3:
        return AppConstants.statusCompleted;

      default:
        return AppConstants.statusAvailable;
    }
  }

  void onFilterTap(int index) {
    selectedIndex.value = index;

    missionsController.fetchMissions(status: getStatus(index));
  }
}
