import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plan_details/upcoming_plan_detail_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/screens/string_constants.dart';
import '../upcoming_plan_model.dart';

class UpcomingPlanCard extends StatelessWidget {
  final UpcomingPlanModel plan;
  const UpcomingPlanCard({required this.plan});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => UpcomingPlanDetailScreen(title: plan.title, planId: plan.id),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColorConstants.lighterGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                    text: plan.title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.black,
                  ),
                  const SizedBox(height: 4),
                  SmallText(
                    text:
                        "${_format(plan.startDate)} - ${_format(plan.endDate)}",
                    fontSize: 12,
                    color: ColorConstants.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  SmallText(
                    text: "${plan.itemCount} ${AppConstants.places}",
                    fontSize: 12,
                    color: ColorConstants.textSecondary,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  String _format(String date) {
    try {
      final d = DateTime.parse(date);
      return "${_month(d.month)} ${d.day}";
    } catch (e) {
      return "";
    }
  }

  String _month(int m) {
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
    return months[m];
  }
}
