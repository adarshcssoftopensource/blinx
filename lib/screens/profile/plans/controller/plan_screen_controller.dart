import 'package:blinx_mobile/screens/profile/plans/controller/plans_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/string_constants.dart';
import '../plans_model.dart';

// ─── Controller ───────────────────────────────────────────────────────────────

class NewPlanScreenController extends GetxController {
  final PlansController plansController = Get.put(
    PlansController(),
    tag: AppConstants.plans,
  );

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final RxList<SavedPlace> selectedPlaces = <SavedPlace>[].obs;
  final RxBool showPlaceDropdown = false.obs;

  final RxString selectedStatus = 'UPCOMING'.obs;
  final List<String> statusOptions = ['UPCOMING', 'SHARED'];

  final RxBool isInitialLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await plansController.fetchSavedPlaces();
      isInitialLoading.value = false;
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  String get dateRangeText {
    if (startDate.value == null || endDate.value == null) return "Select dates";
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[startDate.value!.month]} ${startDate.value!.day} – "
        "${months[endDate.value!.month]} ${endDate.value!.day}, ${endDate.value!.year}";
  }

  Future<void> pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
    }
  }

  Future<void> onCreatePlan(BuildContext context) async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        AppConstants.failed,
        AppConstants.pleaseEnterTitle,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (startDate.value == null || endDate.value == null) {
      Get.snackbar(
        AppConstants.failed,
        AppConstants.pleaseSelectDates,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await plansController.createPlan(
      title: title,
      description: description,
      startDate: DateTime(
        startDate.value!.year,
        startDate.value!.month,
        startDate.value!.day,
      ),
      endDate: DateTime(
        endDate.value!.year,
        endDate.value!.month,
        endDate.value!.day,
      ),
      status: selectedStatus.value,
    );

    if (success) {
      for (final place in selectedPlaces) {
        await plansController.addPlanItem(
          planId: plansController.createdPlanId.value,
          externalId: place.externalId,
          type: place.type,
          name: place.name,
          locationName: place.locationName,
          thumbnailUrl: place.thumbnailUrl,
        );
      }
      Get.snackbar(
        AppConstants.success,
        AppConstants.planCreatedSuccessfully,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } else {
      Get.snackbar(
        AppConstants.failed,

        plansController.errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
