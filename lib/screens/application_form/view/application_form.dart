import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/task_submission/view/task_submission_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/application_form_controller.dart';

// Application form screen for submitting task proposal
class ApplicationFormScreen extends StatelessWidget {
  final String taskId;

  // Receives task ID for submission
  ApplicationFormScreen({super.key, required this.taskId});

  // Injecting ApplicationFormController using GetX
  final ApplicationFormController controller = Get.put(
    ApplicationFormController(),
  );

  // Text controllers for form inputs
  final TextEditingController whyBestFitController = TextEditingController();
  final TextEditingController executionPlanController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();

  // Reactive error messages for validation
  final RxString whyError = ''.obs;
  final RxString executionError = ''.obs;
  final RxString availabilityError = ''.obs;

  // Validates form and submits application to API
  void _submitApplication(BuildContext context) async {
    whyError.value = '';
    executionError.value = '';
    availabilityError.value = '';

    // Field validations
    if (whyBestFitController.text.trim().isEmpty) {
      whyError.value = AppConstants.fieldRequired;
    }
    if (executionPlanController.text.trim().isEmpty) {
      executionError.value = AppConstants.fieldRequired;
    }
    if (availabilityController.text.trim().isEmpty) {
      availabilityError.value = AppConstants.fieldRequired;
    }

    // Stop if any validation error exists
    if (whyError.isNotEmpty ||
        executionError.isNotEmpty ||
        availabilityError.isNotEmpty) {
      return;
    }

    // Fetch stored access token
    final token = await StoreServices.getAccessToken();

    // Handle unauthorized case
    if (token == null || token.isEmpty) {
      Get.snackbar(
        AppConstants.unauthorized,
        AppConstants.loginAgain,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Call controller method to submit application
    final success = await controller.submitApplication(
      taskId: taskId,
      whyBestFit: whyBestFitController.text.trim(),
      executionPlan: executionPlanController.text.trim(),
      availability: availabilityController.text.trim(),
      token: token,
    );

    // Show result snackbar
    Get.snackbar(
      success ? AppConstants.success : AppConstants.notice,
      controller.responseMessage.value,
      snackPosition: SnackPosition.TOP,
      backgroundColor: success ? Colors.green : Colors.redAccent,
      colorText: Colors.white,
    );

    // Navigate to submission screen on success
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TaskSubmissionScreen(
            applicationId:
                controller.applicationFormData.value?.applicationId ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 15,
            width: 15,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppConstants.applicationForm,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      // Reactive UI using Obx
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _jobCard(),
              const SizedBox(height: 24),

              const Text(
                AppConstants.bestFitQuestion,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _textBox(
                controller: whyBestFitController,
                hint: AppConstants.bestFitHint,
              ),
              Obx(() => _errorText(whyError.value)),
              const SizedBox(height: 20),

              const Text(
                AppConstants.executionPlanTitle,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _textBox(
                controller: executionPlanController,
                hint: AppConstants.executionPlanHint,
              ),
              Obx(() => _errorText(executionError.value)),
              const SizedBox(height: 20),

              const Text(
                AppConstants.availabilityTitle,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              _textBox(
                controller: availabilityController,
                hint: AppConstants.availabilityHint,
              ),
              Obx(() => _errorText(availabilityError.value)),
              const SizedBox(height: 40),

              // Submit button
              Center(
                child: SizedBox(
                  width: 230,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _submitApplication(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3478F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            AppConstants.submitApplication,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Displays static job details card
  Widget _jobCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Text(
              AppConstants.creditsPlaceholder,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            AppConstants.taskTitlePlaceholder,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 3),
          const Text(
            AppConstants.categoryPlaceholder,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 5),

          Divider(color: Colors.grey.shade300, height: 1),

          const SizedBox(height: 0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppConstants.expertTier,
                style: TextStyle(fontSize: 14),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 25,
                width: 1,
                color: Colors.grey.shade300,
              ),
              const Text(
                AppConstants.hoursPlaceholder,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable multiline input field
  Widget _textBox({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF51585C)),
        ),
      ),
    );
  }

  // Displays validation error text
  Widget _errorText(String error) {
    if (error.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}
