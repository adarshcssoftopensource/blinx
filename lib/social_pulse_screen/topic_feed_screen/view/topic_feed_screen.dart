import 'package:blinx_mobile/screens/marketplace/view/marketplace.dart';
import 'package:blinx_mobile/screens/missions/view/missions_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/recent_safety_screen/view/recent_safety_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/settings_screen/view/settings_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/controller/topic_list_controller.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/topic_feed_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class TopicFeedScreen extends StatelessWidget {
  const TopicFeedScreen({super.key});

  Color _colorForTopic(String name) {
    switch (name.toLowerCase()) {
      case AppConstants.safety:
        return ColorConstants.safetyBg;
      case AppConstants.environment:
        return ColorConstants.environmentBg;
      case AppConstants.communityEvents:
        return ColorConstants.communityEventsBg;
      case AppConstants.localBusiness:
        return ColorConstants.localBusinessBg;
      case AppConstants.publicSpaces:
        return ColorConstants.publicSpacesBg;
      case AppConstants.infrastructure:
        return ColorConstants.infrastructureBg;
      default:
        return ColorConstants.safetyBg;
    }
  }

  String _iconForTopic(String name) {
    switch (name.toLowerCase()) {
      case AppConstants.safety:
        return AppConstants.safeIcon;
      case AppConstants.environment:
        return AppConstants.environmentIcon;
      case AppConstants.communityEvents:
        return AppConstants.communityIcon;
      case AppConstants.localBusiness:
        return AppConstants.localIcon;
      case AppConstants.publicSpaces:
        return AppConstants.publicIcon;
      case AppConstants.infrastructure:
        return AppConstants.infrastructureIcon;
      default:
        return AppConstants.safeIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TopicListController topicController = Get.put(TopicListController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const LargeText(
          text: AppConstants.selectTopic,
          fontSize: 18,
          fontFamily: Fonts.interSemiBold,
        ),
        titleSpacing: 16,
      ),
      body: Obx(() {
        if (topicController.isLoading.value) {
          return const TopicFeedShimmer();
        }

        if (topicController.topics.isEmpty) {
          return const Center(child: Text(AppConstants.noTopicsFound));
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 1),
          child: GridView.builder(
            itemCount: topicController.topics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 185,
            ),
            itemBuilder: (context, index) {
              final topic = topicController.topics[index];

              return _topicCard(
                id: topic.id,
                title: topic.name,
                color: _colorForTopic(topic.name),
                icon: _iconForTopic(topic.name),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1, color: ColorConstants.divider),
          CustomBottomBar(
            selectedIndex: -1,
            onTap: (index) {
              if (index == 3) return;
              if (index == 0) Get.off(() => const HomeScreen());
              if (index == 1) Get.off(() => const MissionsScreen());
              if (index == 2) Get.off(() => const MarketplaceScreen());
              if (index == 4) Get.off(() => const SettingsScreen());
            },
          ),
        ],
      ),
    );
  }

  Widget _topicCard({
    required String id,
    required String title,
    required Color color,
    required String icon,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RecentSafetyScreen(slug: id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: Center(
                child: Image.asset(
                  '${AppConstants.iconPath}$icon.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, size: 40, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 10),
            LargeText(
              text: title,
              textAlign: TextAlign.center,
              fontFamily: Fonts.interSemiBold,
              color: color == ColorConstants.black
                  ? ColorConstants.white
                  : ColorConstants.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
