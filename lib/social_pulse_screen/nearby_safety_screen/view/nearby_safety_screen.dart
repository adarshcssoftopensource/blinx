import 'package:blinx_mobile/social_pulse_screen/nearby_safety_screen/controller/nearby_safety_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/nearby_safety_screen/model/nearby_safety_model.dart';
import 'package:blinx_mobile/social_pulse_screen/settings_screen/view/settings_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/nearby_shimmer_loader.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';
import '../../../widgets/large_text.dart';
import '../../connection_error_screen/widget/action_box.dart';

class NearbySafetyScreen extends StatelessWidget {
  NearbySafetyScreen({super.key});

  final NearbySafetyController controller = Get.put(NearbySafetyController());

  final RxInt selectedIndex = (-1).obs;

  final RxBool isRecentSelected = false.obs;

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
                        "${ImageConstants.imagePathPng}left_vector.png",
                        width: 15,
                        height: 15,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: MediumText(
                          text: AppConstants.nearby,
                          color: ColorConstants.textPrimary,
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

              // TOGGLE
              Obx(
                () => Center(
                  child: Container(
                    width: 130,
                    height: 27,
                    decoration: BoxDecoration(
                      color: ColorConstants.lighterGreyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // RECENT
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              isRecentSelected.value = true;

                              await Future.delayed(
                                const Duration(milliseconds: 150),
                              );

                              Get.back();
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

                        // NEARBY
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              isRecentSelected.value = false;
                            },
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

      // BODY
      body: Obx(() {
        if (controller.isLoading.value) {
          return const NearbyShimmerLoader();
        }

        if (controller.locationError.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 48, color: Colors.grey),

                const SizedBox(height: 12),

                Text(
                  controller.locationError.value,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: controller.fetchNearbyBlinks,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (controller.blinks.isEmpty) {
          return const Center(
            child: Text(
              "No nearby blinks!",
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
                _feedCard(controller, controller.blinks[index], index),
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

                if (index == 4) {
                  Get.to(() => const SettingsScreen());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _feedCard(
    NearbySafetyController controller,
    NearbySafetyModel blink,
    int index,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
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
                                CommonUi.setPngIcon("verified"),
                                width: 12,
                                height: 12,
                              ),

                              const SizedBox(width: 2),

                              const MediumText(
                                text: "Verified",
                                color: ColorConstants.buttonColor,
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        SmallText(text: _timeAgo(blink.createdAt)),

                        const SmallText(text: " · "),

                        SmallText(
                          text: blink.distanceKm == 0
                              ? blink.locationName
                              : '${blink.distanceKm.toStringAsFixed(1)} km away',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // CONTENT
        Padding(
          padding: const EdgeInsets.only(left: 75, right: 0),
          child: SmallText(text: blink.content),
        ),

        const SizedBox(height: 4),

        // HASHTAG
        Padding(
          padding: const EdgeInsets.only(left: 75, right: 0),
          child: MediumText(text: "#${blink.topic.name}", fontSize: 12),
        ),

        const SizedBox(height: 8),

        // IMAGE
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
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
          ),

        const SizedBox(height: 10),

        // ACTION BUTTONS
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

  static String _timeAgo(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);

      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) return "Just now";

      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";

      if (diff.inHours < 24) return "${diff.inHours}h ago";

      if (diff.inDays < 7) return "${diff.inDays}d ago";

      return "${(diff.inDays / 7).floor()}w ago";
    } catch (e) {
      return "";
    }
  }
}
