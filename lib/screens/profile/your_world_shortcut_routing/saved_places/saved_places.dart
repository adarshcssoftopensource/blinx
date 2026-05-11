import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/controller/saved_places_controller.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/widget/saved_place_card.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/saved_places_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/string_constants.dart';

class SavedPlaces extends StatelessWidget {
  const SavedPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedPlacesController());

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

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
                    child: SmallText(
                      text: AppConstants.savedPlaces,
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

            const SizedBox(height: 18),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const SavedPlacesShimmer();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmallText(
                          text: controller.errorMessage.value,
                          fontSize: 14,
                          color: ColorConstants.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: controller.fetchSavedPlaces,
                          child: const SmallText(
                            text: AppConstants.retry,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.savedPlaces.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorConstants.lighterGreyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const SmallText(
                        text: AppConstants.noSavedPlacesYet,
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        color: ColorConstants.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.savedPlaces.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final place = controller.savedPlaces[index];
                    return SavedPlaceCard(place: place);
                  },
                );
              }),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
