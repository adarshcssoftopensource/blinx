import 'package:blinx_mobile/screens/profile/plans/controller/plans_controller.dart';
import 'package:blinx_mobile/screens/profile/plans/new_plan_screen.dart';
import 'package:blinx_mobile/screens/profile/plans/plan_detail_screen.dart';
import 'package:blinx_mobile/screens/profile/plans/widget/plan_card.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/plans_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  PlansController get controller =>
      Get.put(PlansController(), tag: AppConstants.plans, permanent: false);

  @override
  Widget build(BuildContext context) {
    final ctrl = controller;
    ctrl.fetchUpcomingPlans();

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // AppBar
            Row(
              children: [
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/icons/left_vector.png',
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: SmallText(
                      text: AppConstants.plans,
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

            // Plans list / Empty
            Expanded(
              child: Obx(() {
                if (ctrl.isLoadingUpcoming.value) {
                  return const PlansShimmer();
                }

                if (ctrl.upcomingPlans.isEmpty) {
                  return const Center(
                    child: SmallText(
                      text: AppConstants.noUpcomingPlansYet,
                      fontSize: 14,
                      color: ColorConstants.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.045,
                  ),
                  itemCount: ctrl.upcomingPlans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final plan = ctrl.upcomingPlans[index];
                    return PlanCard(
                      plan: plan,
                      onTap: () => Get.to(
                        () => PlanDetailScreen(
                          title: plan.title,
                          planId: plan.id,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // ── New plan button ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.045,
                10,
                screenWidth * 0.045,
                16,
              ),
              child: GestureDetector(
                onTap: () async {
                  await Get.to(() => const NewPlanScreen());
                  ctrl.fetchUpcomingPlans();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: ColorConstants.blueColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: MediumText(
                      text: AppConstants.newPlan,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: Fonts.interSemiBold,
                      color: ColorConstants.white,
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
