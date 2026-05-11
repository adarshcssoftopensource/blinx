import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plan_details/upcoming_plan_detail_model.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plan_details/upcoming_plan_detail_service.dart';
import 'package:get/get.dart';

class UpcomingPlanDetailController extends GetxController {
  final UpcomingPlanDetailService _service = UpcomingPlanDetailService();
  final String planId;

  UpcomingPlanDetailController({required this.planId});

  final Rxn<UpcomingPlanDetailModel> planDetail =
      Rxn<UpcomingPlanDetailModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _service.getUpcomingPlanDetail(planId);
      if (response.success && response.data != null) {
        planDetail.value = response.data;
      } else {
        errorMessage.value = response.message;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
