import 'package:blinx_mobile/screens/data_preference/view/data_prefrence_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/block_users/view/block_users_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_screen/view/draft_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    final items = [
      AppConstants.language,
      AppConstants.notifications,
      AppConstants.dataPreferences,
      AppConstants.privacySecurity,
      AppConstants.draft,
      AppConstants.blockedUsers,
      AppConstants.changePassword,
    ];

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: LargeText(
                text: AppConstants.settings,
                fontSize: 18,
                fontFamily: Fonts.interSemiBold,
                color: ColorConstants.textPrimary,
              ),
            ),

            const SizedBox(height: 37),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: MediumText(text: AppConstants.manageIndividualAlerts),
            ),

            const SizedBox(height: 10),

            Container(
              height: 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: ColorConstants.white2,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final title = items[index];
                  final isLastItem = index == items.length - 1;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (title == AppConstants.draft) {
                            Get.to(() => const DraftScreen());
                          } else if (title == AppConstants.blockedUsers) {
                            Get.to(() => const BlockedUsersScreen());
                          } else if (title == AppConstants.dataPreferences) {
                            Get.to(() => const DataPreferenceScreen());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            height: 52,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SmallText(
                                      text: title,
                                      fontSize: 13,
                                      color: ColorConstants.textPrimary,
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: ColorConstants.textPrimary,
                                    size: 21,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!isLastItem)
                        Container(
                          height: 0.8,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: ColorConstants.white2,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 1, color: const Color(0xFFEBEBEB)),
            CustomBottomBar(
              selectedIndex: controller.selectedIndex.value,
              onTap: (index) {
                if (index == 4) return;
                controller.selectedIndex.value = index;
              },
            ),
          ],
        ),
      ),
    );
  }
}
