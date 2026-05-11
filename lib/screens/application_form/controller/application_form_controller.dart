import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:get/get.dart';

import '../model/application_form_model.dart';
import '../services/application_form_service.dart';

// Controller for handling application form logic
class ApplicationFormController extends GetxController {
  // Service instance for API calls
  final ApplicationFormService service = ApplicationFormService();

  // Reactive state variables
  var isLoading = false.obs;
  var isSuccess = false.obs;
  var responseMessage = ''.obs;

  // Holds application response data
  Rx<ApplicationFormResponse?> applicationFormData =
      Rx<ApplicationFormResponse?>(null);

  // Stores last API response
  ApplicationFormResponse? lastResponse;

  // Submits task application to backend
  Future<bool> submitApplication({
    required String taskId,
    required String whyBestFit,
    required String executionPlan,
    required String availability,
    String? token,
  }) async {
    try {
      // Set loading state
      isLoading.value = true;
      isSuccess.value = false;
      responseMessage.value = '';

      // Get access token
      final String? accessToken = token ?? await StoreServices.getAccessToken();

      // Handle unauthorized case
      if (accessToken == null || accessToken.isEmpty) {
        responseMessage.value = AppConstants.sessionExpired;
        return false;
      }

      // Call API services
      final response = await service.applyTask(
        taskId: taskId,
        whyBestFit: whyBestFit,
        executionPlan: executionPlan,
        availability: availability,
        token: accessToken,
      );

      // Store response
      lastResponse = response;
      isSuccess.value = response.status;

      // Extract and validate message
      String msg = response.message.trim();
      if (msg.isEmpty) {
        msg = AppConstants.somethingWentWrong;
      }

      // Handle success case
      if (response.status) {
        applicationFormData.value = response;
        responseMessage.value = AppConstants.applicationSubmittedSuccess;
      } else {
        // Handle specific failure cases
        if (msg.toLowerCase().contains('already applied')) {
          responseMessage.value = AppConstants.alreadyApplied;
        } else if (msg.toLowerCase().contains('unauthorized')) {
          responseMessage.value = AppConstants.sessionExpired;
        } else {
          responseMessage.value = msg;
        }
      }
      return response.status;
    } catch (e) {
      // Handle unexpected exceptions
      responseMessage.value = AppConstants.tryAgain;
      return false;
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
}
