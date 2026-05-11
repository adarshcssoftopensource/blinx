import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/shared_plan/controller/shared_plans_controller.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/shared_plan/widget/shared_plan_card.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/shared_plans_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/string_constants.dart';

class SharedPlans extends StatelessWidget {
  const SharedPlans({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SharedPlansController());

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

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
                      text: AppConstants.sharedPlans,
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

            // 🔍 SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppConstants.searchSharedPlans,
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
                  return const SharedPlansShimmer();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmallText(
                          text: controller.errorMessage.value,
                          fontSize: 14,
                          color: ColorConstants.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: controller.fetchSharedPlans,
                          child: const SmallText(
                            text: AppConstants.retry,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.sharedPlans.isEmpty) {
                  return const Center(
                    child: SmallText(
                      text: AppConstants.noSharedPlansYet,
                      fontSize: 14,
                      color: ColorConstants.textSecondary,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.sharedPlans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final plan = controller.sharedPlans[index];
                    return SharedPlanCard(plan: plan);
                  },
                );
              }),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
