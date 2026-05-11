import 'package:get/get.dart';

import '../../../business_logic/store_services.dart';
import '../model/mission_activity_model.dart';
import '../services/mission_activity_services.dart';

class MissionActivityController extends GetxController {
  final MissionActivityServices _services = MissionActivityServices();

  var isLoading = false.obs;
  var activityData = Rxn<MissionActivityModel>();

  Future<void> fetchMissionActivity(String missionId) async {
    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null) return;

      final response = await _services.getMissionActivity(
        token: token,
        missionId: missionId,
      );

      if (response['data']?['status'] == true) {
        activityData.value = MissionActivityModel.fromJson(response);
      } else {
        final message =
            response['message']?.toString() ?? "Failed to load activity";
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
