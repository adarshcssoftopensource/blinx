import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:flutter/material.dart';

class CustomInfoDialog extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final bool isSmall;

  const CustomInfoDialog({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonTap,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 373,
        height: isSmall ? 213 : 274,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: isSmall ? 20 : 28,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: isSmall ? 52 : 60,
              height: isSmall ? 52 : 60,
            ),

            SizedBox(height: isSmall ? 12 : 16),

            // TITLE
            LargeText(
              text: title,
              fontSize: 18,
              fontFamily: Fonts.interSemiBold,
              textAlign: TextAlign.center,
              color: ColorConstants.buttonColor,
            ),

            SizedBox(height: isSmall ? 6 : 8),

            // SUBTITLE
            MediumText(
              text: subtitle,
              fontSize: 12,
              textAlign: TextAlign.center,
              color: ColorConstants.lightGreyColor,
            ),

            const SizedBox(height: 20),
            // BUTTON
            if (buttonText != null) ...[
              ElevatedButton(
                onPressed: onButtonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A73EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: MediumText(
                  text: buttonText!,
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: Fonts.interSemiBold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
