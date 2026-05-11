import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plans/controller/upcoming_plans_controller.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plans/widget/upcoming_plan_card.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:blinx_mobile/widgets/upcoming_places_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/string_constants.dart';

class UpcomingPlaces extends StatelessWidget {
  const UpcomingPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpcomingPlansController());

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // HEADER
            Row(
              children: [
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    'assets/icons/left_vector.png',
                    width: 15,
                    height: 15,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: SmallText(
                      text: AppConstants.upcomingPlans,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: Fonts.interMedium,
                      color: ColorConstants.black,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),

            const SizedBox(height: 18),

            //  SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppConstants.searchPlans,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: controller.onSearchChanged,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  // return const Center(child: CircularProgressIndicator());
                  return const UpcomingPlacesShimmer();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                if (controller.upcomingPlans.isEmpty) {
                  return const Center(
                    child: Text(AppConstants.noUpcomingPlansYet),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.upcomingPlans.length,
                  itemBuilder: (_, index) {
                    final plan = controller.upcomingPlans[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: UpcomingPlanCard(plan: plan),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
