import 'package:blinx_mobile/social_pulse_screen/nearby_safety_screen/view/nearby_safety_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/controller/topic_feed_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/model/topic_feed_model.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/safety_feed_shimmer.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/large_text.dart';
import '../../connection_error_screen/widget/action_box.dart';

class RecentSafetyScreen extends StatelessWidget {
  final String slug;

  RecentSafetyScreen({super.key, required this.slug});

  final RxInt selectedIndex = (-1).obs;

  final RxBool isRecentSelected = true.obs;

  late final TopicFeedController controller = Get.put(
    TopicFeedController(topicId: slug),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),

        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),

                      child: Image.asset(
                        "${ImageConstants.imagePathPng}${AppConstants.leftVector}",
                        width: 15,
                        height: 15,
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: Obx(
                          () => MediumText(
                            text: controller.topicName.value.isEmpty
                                ? slug.capitalizeFirst ?? slug
                                : controller.topicName.value,

                            color: ColorConstants.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 38,
                      width: 38,

                      decoration: BoxDecoration(
                        color: ColorConstants.lighterGreyColor,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(Icons.search, size: 22),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Obx(
                  () => Container(
                    width: 130,
                    height: 27,

                    decoration: BoxDecoration(
                      color: ColorConstants.lighterGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              isRecentSelected.value = true;
                            },

                            child: Container(
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                color: isRecentSelected.value
                                    ? ColorConstants.blueColor
                                    : Colors.transparent,

                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),

                              child: MediumText(
                                text: AppConstants.recent,
                                color: isRecentSelected.value
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.to(() => NearbySafetyScreen()),

                            child: Container(
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                                color: !isRecentSelected.value
                                    ? ColorConstants.blueColor
                                    : Colors.transparent,

                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),

                              child: MediumText(
                                text: AppConstants.nearby,
                                color: !isRecentSelected.value
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const SafetyFeedShimmer();
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),

                const SizedBox(height: 12),

                Text(controller.errorMessage.value),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: controller.fetchTopicFeed,

                  child: const Text(AppConstants.retry),
                ),
              ],
            ),
          );
        }

        if (controller.blinks.isEmpty) {
          return const Center(
            child: Text(
              AppConstants.noBlinksYet,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshFeed,

          child: ListView.builder(
            padding: const EdgeInsets.only(top: 6),

            itemCount: controller.blinks.length,

            itemBuilder: (context, index) =>
                _feedCard(controller.blinks[index], index),
          ),
        );
      }),

      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(height: 1, color: const Color(0xFFEBEBEB)),

            CustomBottomBar(
              selectedIndex: selectedIndex.value,

              onTap: (index) {
                selectedIndex.value = index;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _feedCard(TopicFeedModel blink, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),

          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: ColorConstants.blueColor,
                    width: 1.5,
                  ),
                ),

                child: CircleAvatar(
                  radius: 22,

                  backgroundColor: Colors.grey.shade300,

                  backgroundImage: blink.author.profileImage.isNotEmpty
                      ? NetworkImage(blink.author.profileImage)
                      : null,

                  child: blink.author.profileImage.isEmpty
                      ? const Icon(Icons.person, size: 20, color: Colors.grey)
                      : null,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        LargeText(
                          text: blink.author.name,
                          fontWeight: FontWeight.w700,
                          fontFamily: Fonts.interBold,
                        ),

                        const Spacer(),

                        if (blink.author.isVerified)
                          Row(
                            children: [
                              Image.asset(
                                CommonUi.setPngIcon(AppConstants.verifiedIcon),
                                width: 12,
                                height: 12,
                              ),

                              const SizedBox(width: 2),

                              const MediumText(
                                text: AppConstants.verified,
                                color: ColorConstants.buttonColor,
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 1),

                    Row(
                      children: [
                        SmallText(text: _timeAgo(blink.createdAt)),

                        const SmallText(text: AppConstants.dotSeparator),

                        SmallText(text: blink.locationName),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 75, right: 0),

          child: Text(
            blink.content,

            style: const TextStyle(fontSize: 13, height: 0),
          ),
        ),

        const SizedBox(height: 4),

        Padding(
          padding: const EdgeInsets.only(left: 75, right: 0),

          child: MediumText(text: "#${blink.topic.name}", fontSize: 12),
        ),

        const SizedBox(height: 4),

        if (blink.imageUrl != null && blink.imageUrl!.isNotEmpty)
          Container(
            width: double.infinity,
            height: 230,

            margin: const EdgeInsets.only(left: 68, right: 16),

            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),

            clipBehavior: Clip.antiAlias,

            child: Image.network(
              blink.imageUrl!,
              fit: BoxFit.cover,

              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return ShimmerLoader(
                  height: 230,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                );
              },

              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
          ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 68, right: 16),

          child: Row(
            children: [
              actionBox(
                Icons.favorite,
                blink.likeCount.toString(),
                isActive: blink.isLikedByMe,
              ),

              const SizedBox(width: 8),

              actionBox(
                Icons.chat_bubble_outline,
                blink.commentCount.toString(),
              ),

              const SizedBox(width: 8),

              actionBox(Icons.reply, blink.shareCount.toString()),
            ],
          ),
        ),

        const SizedBox(height: 8),

        if (index != controller.blinks.length - 1)
          Divider(color: ColorConstants.divider, thickness: 1),
      ],
    );
  }

  String _timeAgo(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);

      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) {
        return AppConstants.justNow;
      }

      if (diff.inMinutes < 60) {
        return "${diff.inMinutes}${AppConstants.minuteAgo}";
      }

      if (diff.inHours < 24) {
        return "${diff.inHours}${AppConstants.hourAgo}";
      }

      if (diff.inDays < 7) {
        return "${diff.inDays}${AppConstants.dayAgo}";
      }

      return "${(diff.inDays / 7).floor()}${AppConstants.weekAgo}";
    } catch (e) {
      return AppConstants.empty;
    }
  }
}
