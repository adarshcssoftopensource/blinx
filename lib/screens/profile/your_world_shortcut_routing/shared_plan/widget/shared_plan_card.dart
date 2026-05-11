import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/screens/string_constants.dart';
import '../../shared_plan_detail/shared_plan_detail_screen.dart';

class SharedPlanCard extends StatelessWidget {
  final dynamic plan;

  const SharedPlanCard({required this.plan});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => SharedPlanDetailScreen(title: plan.title, planId: plan.id),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.lighterGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Container(
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ColorConstants.blueColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: ColorConstants.blueColor,
                      ),
                    ),
                    Positioned(
                      bottom: 7,
                      right: 7,
                      child: Icon(
                        Icons.people,
                        size: 18,
                        color: ColorConstants.blueColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 0,
                  children: [
                    SmallText(
                      text: plan.title ?? "",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.black,
                      height: 1.2,
                    ),
                    SmallText(
                      text: plan.ownerLabel ?? "",
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                      height: 1.2,
                    ),
                    SmallText(
                      // text: '${plan.itemCount ?? 0} items',
                      text:
                          '${plan.itemCount ?? 0} ${AppConstants.place}${(plan.itemCount ?? 0) > 1 ? 's' : ''}',
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                      height: 1.2,
                    ),
                    SmallText(
                      text: _formatDate(plan.lastUpdated),
                      fontSize: 12,
                      color: ColorConstants.textSecondary,
                      height: 1.2,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
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
