import 'package:blinx_mobile/social_pulse_screen/draft_details_screen/view/draft_details.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_screen/controller/draft_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_screen/model/draft_model.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/draft_shimmer_loader.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';
import '../../../widgets/large_text.dart';

class DraftScreen extends StatelessWidget {
  const DraftScreen({super.key});

  DraftController get _controller => Get.put(DraftController());

  @override
  Widget build(BuildContext context) {
    final RxInt selectedIndex = (-1).obs;

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const HomeScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        // HEADER
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.offAll(() => const HomeScreen()),
                        child: Image.asset(
                          "${ImageConstants.imagePathPng}left_vector.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: MediumText(
                            text: AppConstants.draft,
                            color: ColorConstants.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        body: Obx(() {
          if (_controller.isLoading.value) {
            return const DraftShimmerLoader();
          }

          if (_controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _controller.fetchDrafts,
                    child: const Text(AppConstants.retry),
                  ),
                ],
              ),
            );
          }

          if (_controller.drafts.isEmpty) {
            return const Center(child: Text(AppConstants.noDraftsFound));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemCount: _controller.drafts.length,
            itemBuilder: (context, index) =>
                _feedCard(_controller.drafts[index], index),
          );
        }),

        // BOTTOM BAR
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
      ),
    );
  }

  // FEED CARD
  Widget _feedCard(DraftModel item, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DraftDetailsScreen(draft: item));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                // AVATAR
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: item.author.profileImage != null
                      ? NetworkImage(item.author.profileImage!)
                      : null,
                  child: item.author.profileImage == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LargeText(
                            text: item.author.name,
                            fontWeight: FontWeight.w700,
                            fontFamily: Fonts.interBold,
                          ),

                          const Spacer(),

                          // DRAFT BADGE
                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/draft.png",
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(width: 4),
                              const MediumText(
                                text: "Draft",
                                color: ColorConstants.buttonColor,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Row(
                        children: [
                          SmallText(
                            text: _controller.formatTime(item.createdAt),
                          ),
                          const SmallText(text: " · "),
                          SmallText(text: item.locationName),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // DESCRIPTION
          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: SmallText(text: item.content),
          ),

          const SizedBox(height: 4),

          // HASHTAG
          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: MediumText(text: "#${item.topic.name}", fontSize: 12),
          ),

          const SizedBox(height: 8),

          // IMAGE
          if (item.imageUrl != null)
            Container(
              width: double.infinity,
              height: 297,
              margin: const EdgeInsets.only(left: 71, right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                item.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return ShimmerLoader(
                    height: 297,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(12),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

          const SizedBox(height: 20),

          if (index != _controller.drafts.length - 1)
            Divider(color: ColorConstants.divider, thickness: 1),
        ],
      ),
    );
  }
}
