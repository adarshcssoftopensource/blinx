import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';
import 'controller/tune_your_world_controller.dart';

class TuneYourWorld extends StatelessWidget {
  const TuneYourWorld({super.key});

  TuneYourWorldController get controller {
    final ctrl = Get.put(TuneYourWorldController());
    ctrl.fetchInterests();
    return ctrl;
  }

  Color _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return const Color(0xFFF5F5F0);
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'utensils':
        return Icons.restaurant;
      case 'music':
        return Icons.music_note;
      case 'trophy':
        return Icons.emoji_events;
      case 'moon':
        return Icons.nightlight_round;
      case 'tree':
        return Icons.park;
      case 'theater-masks':
        return Icons.theater_comedy;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl =
        controller; // ek baar lelo — build mein baar baar getter na chale
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 16 * 2 - 12) / 2;
    const cardHeight = 95.0;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // BACK
            Row(
              children: [
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    'assets/icons/left_vector.png',
                    width: 15,
                    height: 15,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: LargeText(
                      text: AppConstants.tuneYourWorld,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: Fonts.interMedium,
                      color: ColorConstants.black,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),

            const SizedBox(height: 30),

            // GRID
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 20,
                      children: List.generate(6, (index) {
                        return ShimmerLoader(
                          height: 95,
                          width: cardWidth,
                          borderRadius: BorderRadius.circular(12),
                        );
                      }),
                    ),
                  );
                }

                final interests = ctrl.interestsList;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 20,
                    children: List.generate(interests.length, (index) {
                      final interest = interests[index];
                      final isSelected = ctrl.selectedIds.contains(interest.id);

                      return GestureDetector(
                        onTap: () => ctrl.toggleInterest(interest.id),
                        child: Container(
                          width: cardWidth,
                          height: cardHeight,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorConstants.blueColor
                                : _hexToColor(interest.color),
                            border: Border.all(
                              color: isSelected
                                  ? ColorConstants.textPrimary
                                  : ColorConstants.lighterGreyColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _getIcon(interest.icon),
                                size: 22,
                                color: isSelected
                                    ? ColorConstants.white
                                    : ColorConstants.textPrimary,
                              ),
                              const Spacer(),
                              SmallText(
                                text: interest.name,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? ColorConstants.white
                                    : ColorConstants.textPrimary,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // SAVE BUTTON - hide if all already saved
            Obx(() {
              final allSaved = ctrl.interestsList.every(
                (i) => i.isAlreadySaved,
              );

              if (allSaved) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => ctrl.saveInterests(),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: ColorConstants.blueColor,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    alignment: Alignment.center,
                    child: SmallText(
                      text: AppConstants.saveInterests,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: ColorConstants.white,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
