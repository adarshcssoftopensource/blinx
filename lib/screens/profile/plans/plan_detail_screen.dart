import 'package:blinx_mobile/screens/profile/plans/controller/plans_controller.dart';
import 'package:blinx_mobile/screens/profile/plans/saved_places.dart';
import 'package:blinx_mobile/screens/profile/plans/widget/add_place_button.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/plan_detail_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';

class PlanDetailScreen extends StatelessWidget {
  final String title;
  final String planId;
  final bool fromUpcoming;

  PlanDetailScreen({
    super.key,
    required this.title,
    required this.planId,
    this.fromUpcoming = false,
  }) {
    // initState ka kaam yahan constructor mein — GetX controller ready hote hi call hoga
    _init();
  }

  final PlansController controller = Get.put(PlansController(), tag: 'plans');

  Future<void> _init() async {
    controller.planItems.clear();
    await controller.fetchUpcomingPlanById(planId);

    final plan = controller.upcomingPlanDetails.value;
    if (plan != null) {
      for (final item in plan.items) {
        controller.planItems.add({
          "id": item.id,
          "externalId": item.externalId,
          "name": item.name,
          "locationName": item.locationName,
          "thumbnailUrl": item.thumbnailUrl,
          "type": item.type,
        });
      }
    }
  }

  Future<void> _onAddPlaceTapped() async {
    await Get.to(() => SavedPlacesScreen(planId: planId));
    await _init(); // reload after returning
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── APP BAR ──
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
                  Expanded(
                    child: MediumText(
                      text: title,
                      fontSize: 16,
                      fontFamily: Fonts.interSemiBold,
                      color: ColorConstants.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
              child: const SmallText(
                text: AppConstants.savedPlaces,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ColorConstants.black,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const PlanDetailShimmer();
                }

                final items = controller.planItems;

                // ── EMPTY STATE ──
                if (items.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.045,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        const Icon(
                          Icons.location_off_outlined,
                          size: 70,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 18),
                        const MediumText(
                          text: AppConstants.noPlacesAddedYet,
                          fontSize: 15,
                          fontFamily: Fonts.interSemiBold,
                          color: ColorConstants.black,
                        ),
                        const SizedBox(height: 8),
                        const SmallText(
                          text: AppConstants.addPlacesToTripPlan,
                          fontSize: 12,
                          color: ColorConstants.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        AddPlaceButton(onTap: _onAddPlaceTapped),
                      ],
                    ),
                  );
                }

                // ── ITEMS LIST ──
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.045,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F0),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Row(
                                children: [
                                  if ((item["thumbnailUrl"] ?? "")
                                      .toString()
                                      .isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item["thumbnailUrl"]!,
                                        width: 58,
                                        height: 58,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _placeholderImage(),
                                      ),
                                    )
                                  else
                                    _placeholderImage(),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MediumText(
                                          text: item["name"] ?? "",
                                          fontSize: 13,
                                          fontFamily: Fonts.interSemiBold,
                                          color: ColorConstants.black,
                                        ),
                                        const SizedBox(height: 5),
                                        SmallText(
                                          text: item["locationName"] ?? "",
                                          fontSize: 11,
                                          color: ColorConstants.textSecondary,
                                        ),
                                        const SizedBox(height: 8),
                                        if ((item["type"] ?? "")
                                            .toString()
                                            .isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8F0FE),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: SmallText(
                                              text: item["type"] ?? "",
                                              fontSize: 10,
                                              color: ColorConstants.blueColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (!fromUpcoming)
                        AddPlaceButton(onTap: _onAddPlaceTapped),

                      const SizedBox(height: 12),

                      if (!fromUpcoming)
                        Obx(
                          () => GestureDetector(
                            onTap: controller.isLoading.value
                                ? null
                                : () => Navigator.pop(context),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: controller.isLoading.value
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black54,
                                        ),
                                      )
                                    : SmallText(
                                        text: AppConstants.continuePlanning,
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 18),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.location_on_outlined, color: Colors.grey),
    );
  }
}
