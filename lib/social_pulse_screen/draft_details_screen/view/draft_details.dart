import 'package:blinx_mobile/social_pulse_screen/draft_details_screen/controller/draft_details_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_screen/model/draft_model.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/controller/home_screen_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DraftDetailsScreen extends StatelessWidget {
  final DraftModel draft;

  const DraftDetailsScreen({super.key, required this.draft});

  DraftDetailsController get _controller => Get.put(DraftDetailsController());

  String _formatTime(DateTime createdAt) {
    final Duration diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";

    return "${(diff.inDays / 7).floor()}w ago";
  }

  Future<void> _onPublish() async {
    await _controller.publishDraft(draft.id);

    if (_controller.isSuccess.value) {
      Get.snackbar(
        "Success",
        "Draft published successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      if (Get.isRegistered<HomeScreenController>()) {
        await Get.find<HomeScreenController>().fetchFeed(isRefresh: true);
      }

      Get.offAll(() => const HomeScreen());
    } else {
      Get.snackbar(
        "Error",
        _controller.errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // HEADER
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
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

                const SizedBox(width: 10),

                const Expanded(
                  child: Center(
                    child: MediumText(text: AppConstants.draftDetails),
                  ),
                ),

                const SizedBox(width: 25),
              ],
            ),
          ),
        ),
      ),

      // BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // USER ROW
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2A73EA),
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: draft.author.profileImage != null
                        ? NetworkImage(draft.author.profileImage!)
                        : null,
                    child: draft.author.profileImage == null
                        ? const Icon(Icons.person, color: Colors.white)
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
                            text: draft.author.name,
                            fontWeight: FontWeight.w700,
                            fontFamily: Fonts.interBold,
                          ),

                          const Spacer(),

                          Row(
                            children: [
                              Image.asset(
                                "assets/icons/draft.png",
                                width: 14,
                                height: 14,
                              ),

                              const SizedBox(width: 4),

                              const MediumText(
                                text: AppConstants.draft,
                                color: ColorConstants.buttonColor,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Row(
                        children: [
                          SmallText(text: _formatTime(draft.createdAt)),

                          const SmallText(text: " · "),

                          SmallText(text: draft.locationName),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: SmallText(text: draft.content),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: MediumText(
              text: "#${draft.topic.name}",
              fontSize: 12,
              color: ColorConstants.buttonColor,
            ),
          ),

          const SizedBox(height: 10),

          if (draft.imageUrl != null)
            Container(
              width: double.infinity,
              height: 250,
              margin: const EdgeInsets.only(left: 68, right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                draft.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return ShimmerLoader(
                    height: 250,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(16),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),

          const Spacer(),

          SafeArea(
            top: false,
            child: Obx(() {
              final isPublishing = _controller.isPublishing.value;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: isPublishing ? null : () => Get.back(),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: LargeText(
                            text: AppConstants.save,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: Fonts.interSemiBold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: isPublishing ? null : _onPublish,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: isPublishing
                                ? Colors.grey.shade400
                                : ColorConstants.primaryBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: isPublishing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : LargeText(
                                  text: AppConstants.publish,
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: Fonts.interSemiBold,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
