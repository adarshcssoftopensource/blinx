import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:flutter/material.dart';

import '../../../../utils/screens/string_constants.dart';

class AddPlaceButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddPlaceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: ColorConstants.blueColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Center(
          child: MediumText(
            text: AppConstants.addPlace,
            fontSize: 14,
            fontFamily: Fonts.interSemiBold,
            color: ColorConstants.white,
          ),
        ),
      ),
    );
  }
}
