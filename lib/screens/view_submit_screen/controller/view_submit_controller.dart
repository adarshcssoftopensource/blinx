import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:get/get.dart';

import '../model/view_submit_model.dart';
import '../services/view_submit_services.dart';

class ViewSubmitController extends GetxController {
  final isLoading = false.obs;
  final submitData = Rxn<ViewSubmitData>();
  final ViewSubmitServices services = ViewSubmitServices();

  Future<void> fetchViewSubmit(String missionId) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) throw "No access token found";

      final response = await services.getSubmission(token, missionId);

      if (response.success && response.data != null) {
        submitData.value = ViewSubmitData.fromJson(response.data!);
      } else {
        Get.snackbar(
          "Failed",
          response.message.isNotEmpty
              ? response.message
              : "Failed to load submission",
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
