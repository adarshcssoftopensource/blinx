import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/shared_plans_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/string_constants.dart';
import '../../plans/plan_shimmer.dart';
import 'controller/shared_plan_detail_controller.dart';

class SharedPlanDetailScreen extends StatelessWidget {
  final String title;
  final String planId;

  const SharedPlanDetailScreen({
    super.key,
    required this.title,
    required this.planId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SharedPlanDetailController(planId: planId));

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      text: AppConstants.sharedPlanDetail,
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

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const SharedPlansShimmer();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }

                final plan = controller.planDetail.value;
                if (plan == null) return const SizedBox();

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // INFO CARD
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ColorConstants.lighterGreyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(
                            text: plan.title,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black,
                          ),
                          const SizedBox(height: 6),
                          if (plan.description.isNotEmpty)
                            SmallText(
                              text: plan.description,
                              fontSize: 13,
                              color: ColorConstants.textSecondary,
                            ),
                          const SizedBox(height: 6),
                          SmallText(
                            text:
                                "${_formatDate(plan.startDate)} - ${_formatDate(plan.endDate)}",
                            fontSize: 12,
                            color: ColorConstants.textSecondary,
                          ),
                        ],
                      ),
                    ),

                    if (plan.items.isNotEmpty) ...[
                      const SizedBox(height: 18),

                      const SmallText(
                        text: AppConstants.places,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.black,
                      ),

                      const SizedBox(height: 12),

                      ...plan.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstants.lighterGreyColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    item.thumbnailUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return ShimmerBox(
                                            width: 80,
                                            height: 80,
                                          );
                                        },
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 4,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallText(
                                          text: item.name,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstants.black,
                                        ),
                                        const SizedBox(height: 4),
                                        SmallText(
                                          text: item.locationName,
                                          fontSize: 12,
                                          color: ColorConstants.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.savePlan(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.blueColor,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      elevation: 4,
                    ),
                    child: const SmallText(
                      text: AppConstants.saveToMyPlans,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      const months = [
        "",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[d.month]} ${d.day}, ${d.year}";
    } catch (e) {
      return date;
    }
  }
}
