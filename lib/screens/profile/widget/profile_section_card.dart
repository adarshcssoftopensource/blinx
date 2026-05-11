import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const ProfileSectionCard({required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 65,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.white2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediumText(
              text: title,
              fontSize: 13,
              fontFamily: Fonts.interSemiBold,
              color: ColorConstants.textPrimary,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              SmallText(
                text: subtitle!,
                fontSize: 11,
                color: ColorConstants.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
