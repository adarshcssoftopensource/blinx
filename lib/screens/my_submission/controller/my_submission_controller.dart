import 'package:blinx_mobile/screens/my_submission/services/my_submission_services.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:get/get.dart';

import '../model/my_submission_model.dart';

class MySubmissionController extends GetxController {
  final MySubmissionService mySubmissionService = MySubmissionService();

  // Reactive variable to hold the API response data
  Rx<MySubmissionsResponse?> mySubmissionData = Rx<MySubmissionsResponse?>(
    null,
  );

  // Observable boolean to track loading state
  var isLoading = false.obs;

  Future<void> getMySubmissionApi() async {
    isLoading.value = true;
    try {
      var response = await mySubmissionService.getSMySubmissionService();

      // Store response data if API call succeeds, else show error snackbar
      if (response.success) {
        mySubmissionData.value = response.data;
      } else {
        Get.snackbar(
          AppConstants.failed,
          response.message ?? AppConstants.somethingWentWrong,
        );
      }
    } catch (e, stace) {
      // Show exception message to user on unexpected error
      Get.snackbar(AppConstants.failed, e.toString());
    } finally {
      // Reset loading state after API call completes
      isLoading.value = false;
    }
  }
}
