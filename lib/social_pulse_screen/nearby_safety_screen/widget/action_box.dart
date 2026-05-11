import 'package:flutter/material.dart';

import '../../../utils/screens/color_constants.dart';
import '../../../widgets/small_text.dart';

Widget actionBox(
  IconData icon,
  String count, {
  bool isActive = false,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 51,
      height: 31,
      decoration: BoxDecoration(
        color: ColorConstants.commentBubbleColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon == Icons.favorite
                ? (isActive ? Icons.favorite : Icons.favorite_border)
                : icon,
            size: 14,
            color: isActive && icon == Icons.favorite ? Colors.red : null,
          ),

          const SizedBox(width: 4),

          SmallText(text: count),
        ],
      ),
    ),
  );
}
