import 'dart:async';

import 'package:get/get.dart';

import '../shared_plan_model.dart';
import '../shared_plans_service.dart';

class SharedPlansController extends GetxController {
  final SharedPlansService _service = SharedPlansService();

  final RxList<SharedPlanModel> sharedPlans = <SharedPlanModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchSharedPlans();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchSharedPlans(search: query);
    });
  }

  Future<void> fetchSharedPlans({String search = ""}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.getSharedPlans(search: search);

      if (response.success && response.data != null) {
        sharedPlans.assignAll(response.data!);
      } else {
        errorMessage.value = response.message;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
