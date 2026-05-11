import 'package:blinx_mobile/screens/profile/plans/plans_model.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';

import '../../../../utils/screens/string_constants.dart';

// ── Plan Card ── (already stateless tha, unchanged)
class PlanCard extends StatelessWidget {
  final UpcomingPlan plan;
  final VoidCallback onTap;

  const PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.white2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumText(
                    text: plan.title,
                    fontSize: 13,
                    fontFamily: Fonts.interSemiBold,
                    color: ColorConstants.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  SmallText(
                    text: plan.formattedDates,
                    fontSize: 11,
                    color: ColorConstants.textSecondary,
                  ),
                  if (plan.itemCount > 0) ...[
                    const SizedBox(height: 4),
                    SmallText(
                      text:
                          "${plan.itemCount} ${AppConstants.place}${plan.itemCount > 1 ? 's' : ''}",
                      fontSize: 11,
                      color: ColorConstants.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38, size: 18),
          ],
        ),
      ),
    );
  }
}
