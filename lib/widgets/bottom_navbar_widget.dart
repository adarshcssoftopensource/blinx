import 'package:blinx_mobile/map/mapping_screen.dart';
import 'package:blinx_mobile/screens/marketplace/view/marketplace.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/settings_screen/view/settings_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/view/topic_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<String> _icons = [
    "assets/icons/homes.png",
    "assets/icons/Missions.png",
    "assets/icons/marketplaces.png",
    "assets/icons/topic.png",
    "assets/icons/settings.png",
  ];

  void _handleTap(int index) {
    onTap(index);
    switch (index) {
      case 0:
        Get.offAll(() => const HomeScreen());
        break;

      case 1:
        Get.to(
          () => MappingScreen(),
          preventDuplicates: false,
          transition: Transition.noTransition,
        );
        break;
      case 2:
        Get.to(
          () => const MarketplaceScreen(),
          preventDuplicates: false,
          transition: Transition.noTransition,
        );
        break;
      case 3:
        Get.to(
          () => const TopicFeedScreen(),
          preventDuplicates: false,
          transition: Transition.noTransition,
        );
        break;
      case 4:
        Get.to(
          () => const SettingsScreen(),
          preventDuplicates: false,
          transition: Transition.noTransition,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double figmaNavbarWidth = 400;
    const double figmaLeftPadding = 20;
    const double figmaIconSize = 26;
    const int iconCount = 5;

    final scale = screenWidth / figmaNavbarWidth;
    final iconSize = figmaIconSize * scale;
    final horizontalPadding = figmaLeftPadding * scale * 2;
    final availableWidth = screenWidth - horizontalPadding;
    final totalIconWidth = iconSize * iconCount;
    final gap = (availableWidth - totalIconWidth) / (iconCount - 1);

    return Container(
      height: 80 * scale + MediaQuery.of(context).padding.bottom,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          left: figmaLeftPadding * scale,
          right: figmaLeftPadding * scale,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(iconCount * 2 - 1, (i) {
            if (i.isOdd) return SizedBox(width: gap);
            final index = i ~/ 2;
            return _tapZone(index, iconSize);
          }),
        ),
      ),
    );
  }

  Widget _tapZone(int index, double iconSize) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(index),
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Image.asset(
          _icons[index],
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          color: Colors.black87,
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}
