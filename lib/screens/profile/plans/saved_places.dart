import 'package:blinx_mobile/screens/profile/plans/controller/plans_controller.dart';
import 'package:blinx_mobile/screens/profile/plans/plans_model.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/saved_places_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';

class SavedPlacesScreen extends StatelessWidget {
  final String planId;

  SavedPlacesScreen({super.key, required this.planId}) {
    _init();
  }

  final PlansController controller = Get.put(PlansController(), tag: 'plans');

  Future<void> _init() async {
    // Always refresh saved places list on open
    await controller.fetchSavedPlaces();

    // Pre-select places already in planItems
    for (final item in controller.planItems) {
      final match = controller.savedPlaces.firstWhereOrNull(
        (e) => e.externalId == item["externalId"],
      );
      if (match != null && !controller.selectedPlaces.contains(match)) {
        controller.selectedPlaces.add(match);
      }
    }
  }

  bool isSelected(SavedPlace place) =>
      controller.selectedPlaces.any((e) => e.id == place.id);

  void toggleSelection(SavedPlace place) {
    if (isSelected(place)) {
      controller.selectedPlaces.removeWhere((e) => e.id == place.id);
    } else {
      controller.selectedPlaces.add(place);
    }
  }

  Future<void> onSavePlanning(BuildContext context) async {
    if (controller.selectedPlaces.isEmpty || controller.isSaving.value) return;

    controller.isSaving.value = true;

    bool allSuccess = true;

    for (final place in controller.selectedPlaces) {
      // Skip if already persisted in planItems (avoid duplicate API calls)
      final alreadyAdded = controller.planItems.any(
        (item) => item["externalId"] == place.externalId,
      );
      if (alreadyAdded) continue;

      final success = await controller.addPlanItem(
        planId: planId,
        externalId: place.externalId,
        type: place.type,
        name: place.name,
        locationName: place.locationName,
        thumbnailUrl: place.thumbnailUrl,
      );

      if (!success) allSuccess = false;
    }

    // Refresh plans list so Plans screen reflects the new item count
    await controller.fetchUpcomingPlans();

    controller.isSaving.value = false;

    if (allSuccess) {
      Get.rawSnackbar(
        messageText: Row(
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              AppConstants.planSavedSuccessfully,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 400));

      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Get.rawSnackbar(
        messageText: Text(
          controller.errorMessage.value.isNotEmpty
              ? controller.errorMessage.value
              : AppConstants.failedToSavePlaces,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: Colors.red.shade700,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─────────────── AppBar ───────────────
            Container(
              color: ColorConstants.blueColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/icons/left_vector.png',
                      width: 15,
                      height: 15,
                      color: ColorConstants.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: MediumText(
                      text: AppConstants.savedPlaces,
                      fontSize: 14,
                      fontFamily: Fonts.interMedium,
                      color: ColorConstants.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: SmallText(
                  text: AppConstants.selectPlaces,
                  fontSize: 13,
                  color: ColorConstants.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─────────────── Places List ───────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoadingSavedPlaces.value) {
                  return const SavedPlacesShimmer();
                }
                if (controller.savedPlaces.isEmpty) {
                  return const Center(
                    child: SmallText(
                      text: AppConstants.noSavedPlacesFound,
                      fontSize: 13,
                      color: ColorConstants.textSecondary,
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.045,
                  ),
                  itemCount: controller.savedPlaces.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final place = controller.savedPlaces[index];
                    // Obx per-item taaki sirf yahi tile rebuild ho selection pe
                    return Obx(() {
                      final selected = isSelected(place);
                      return GestureDetector(
                        onTap: () => toggleSelection(place),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Row(
                            children: [
                              // ───────── Image ─────────
                              if (place.thumbnailUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    place.thumbnailUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.location_on_outlined),
                                ),

                              const SizedBox(width: 12),

                              // ───────── Text ─────────
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MediumText(
                                      text: place.name,
                                      fontSize: 13,
                                      fontFamily: Fonts.interSemiBold,
                                      color: ColorConstants.black,
                                    ),
                                    const SizedBox(height: 4),
                                    SmallText(
                                      text: place.locationName,
                                      fontSize: 11,
                                      color: ColorConstants.textSecondary,
                                    ),
                                  ],
                                ),
                              ),

                              // ───────── Selection Circle ─────────
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected
                                      ? ColorConstants.blueColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selected
                                        ? ColorConstants.blueColor
                                        : Colors.black26,
                                  ),
                                ),
                                child: selected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            // ─────────────── Save Planning Button ───────────────
            Obx(
              () => Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.045,
                  10,
                  screenWidth * 0.045,
                  20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (controller.selectedPlaces.isEmpty ||
                            controller.isSaving.value)
                        ? null
                        : () => onSavePlanning(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.blueColor,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : MediumText(
                            text: AppConstants.savePlanning,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: Fonts.interSemiBold,
                            color: controller.selectedPlaces.isEmpty
                                ? Colors.black45
                                : ColorConstants.white,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
