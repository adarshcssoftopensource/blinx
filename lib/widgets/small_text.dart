import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String fontFamily;
  final TextDecoration? decoration;
  final int maxLines;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;

  const SmallText({
    super.key,
    required this.text,
    this.fontSize = 12.0,
    this.fontWeight = FontWeight.w400,
    this.color = ColorConstants.lightGreyColor,
    this.fontFamily = Fonts.interRegular,
    this.decoration,
    this.maxLines = 2,
    this.textAlign,
    this.height,
    this.letterSpacing,
    this.fontStyle,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow:
          overflow ??
          (maxLines == 1 ? TextOverflow.ellipsis : TextOverflow.visible),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
        fontStyle: fontStyle ?? FontStyle.normal,
      ),
    );
  }
}
