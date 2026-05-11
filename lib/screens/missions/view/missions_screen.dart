import 'package:blinx_mobile/screens/marketplace/view/marketplace.dart';
import 'package:blinx_mobile/screens/missions/widgets/mission_card_widget.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/settings_screen/view/settings_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/view/topic_feed_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/missions_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mission_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class MissionsScreen extends StatelessWidget {
  const MissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MissionsScreenStateController());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,

        backgroundColor: Colors.white,

        leadingWidth: 42,

        leading: GestureDetector(
          onTap: () => Navigator.pop(context),

          child: Center(
            child: SizedBox(
              width: 15,

              height: 15,

              child: Image.asset(
                CommonUi.setPngIcon("left_vector"),

                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        title: const Text(
          AppConstants.missionDetailTitle,

          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),

        centerTitle: true,

        elevation: 0,
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(height: 1, color: const Color(0xFFEBEBEB)),

          Obx(
            () => CustomBottomBar(
              selectedIndex: controller.bottomNavIndex.value,

              onTap: (index) {
                controller.bottomNavIndex.value = index;

                if (index == 1) return;

                if (index == 0) Get.offAll(() => const HomeScreen());

                if (index == 2) Get.offAll(() => const MarketplaceScreen());

                if (index == 3) Get.offAll(() => const TopicFeedScreen());

                if (index == 4) Get.offAll(() => const SettingsScreen());
              },
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: Row(
                children: List.generate(controller.filters.length, (index) {
                  final bool isSelected =
                      controller.selectedIndex.value == index;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == controller.filters.length - 1 ? 0 : 6,
                      ),

                      child: GestureDetector(
                        onTap: () => controller.onFilterTap(index),

                        child: Container(
                          height: 32,

                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2A73EA)
                                : const Color(0xFFFFFFFF),

                            borderRadius: BorderRadius.circular(50),

                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2A73EA)
                                  : const Color(0xFFD0D5DD),
                            ),
                          ),

                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),

                              child: Text(
                                controller.filters[index],

                                style: TextStyle(
                                  fontSize: 12,

                                  fontWeight: FontWeight.w500,

                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Obx(() {
              final mc = controller.missionsController;

              if (mc.isLoading.value) return const MissionsShimmer();

              if (mc.missionsList.isEmpty) {
                return const Center(
                  child: Text(
                    AppConstants.noMissionsAvailable,

                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: mc.missionsList.length,

                itemBuilder: (context, index) {
                  final mission = mc.missionsList[index];

                  return MissionCard(
                    title: mission.title ?? "",

                    description: mission.description ?? "",

                    price: "${mission.credits} CR",

                    missionId: mission.id ?? "",

                    isSubmitted: controller.selectedIndex.value == 2,

                    isActive: controller.selectedIndex.value == 1,

                    isCompleted: controller.selectedIndex.value == 3,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
