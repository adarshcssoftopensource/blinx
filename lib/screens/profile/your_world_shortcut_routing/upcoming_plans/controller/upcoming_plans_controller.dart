import 'dart:async';

import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plans/upcoming_plan_model.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plans/upcoming_plans_service.dart';
import 'package:get/get.dart';

class UpcomingPlansController extends GetxController {
  final UpcomingPlansService _service = UpcomingPlansService();

  final RxList<UpcomingPlanModel> upcomingPlans = <UpcomingPlanModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingPlans();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchUpcomingPlans(search: query);
    });
  }

  Future<void> fetchUpcomingPlans({String search = ""}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getUpcomingPlans(search: search);

      if (response.success && response.data != null) {
        upcomingPlans.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
