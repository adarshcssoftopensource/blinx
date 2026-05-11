import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:get/get.dart';

import '../model/missions_screen_model.dart';
import '../services/missions_screen_services.dart';

class MissionsScreenController extends GetxController {
  final MissionsScreenServices _services = MissionsScreenServices();

  var missionsList = <MissionModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchMissions({
    String status = "available",
    int page = 1,
    int limit = 20,
  }) async {
    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();

      if (token == null || token.isEmpty) {
        missionsList.clear();
        return;
      }

      final response = await _services.getMissions(
        token: token,
        status: status,
        page: page,
        limit: limit,
      );

      // FIXED RESPONSE PARSING
      final data = response['data'];

      if (data != null && data['status'] == true) {
        final List missions = data['missions'] ?? [];

        missionsList.value = missions
            .map((e) => MissionModel.fromJson(e))
            .toList();
      } else {
        missionsList.clear();
      }
    } catch (e) {
      missionsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchMissions();
    super.onInit();
  }
}
