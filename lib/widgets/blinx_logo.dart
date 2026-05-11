import 'package:flutter/material.dart';

class BlinxLogo extends StatelessWidget {
  const BlinxLogo({super.key});

  @override
  Widget build(BuildContext context) {
    const double logoSize = 80;

    return Image.asset(
      "assets/icons/blinx.png",
      height: logoSize ,
      fit: BoxFit.contain,
    );
  }
}
