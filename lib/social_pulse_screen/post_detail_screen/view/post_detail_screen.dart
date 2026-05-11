import 'package:blinx_mobile/social_pulse_screen/report_screen/view/report_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/widgets/post_detail_shimmer.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';
import '../controller/post_detail_controller.dart';
import '../model/post_detail_model.dart';

class PostDetailScreen extends StatelessWidget {
  final String blinkId;

  const PostDetailScreen({super.key, required this.blinkId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostDetailController(blinkId: blinkId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          AppConstants.blinkDetails,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            width: 15,
            height: 15,
            fit: BoxFit.contain,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // LOADING
        if (controller.isLoading.value) {
          return const PostDetailShimmer();
        }

        // ERROR
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchDetail(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A73EA),
                  ),
                  child: const Text(
                    AppConstants.retry,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        // NO DATA
        if (controller.blink.value == null) {
          return const Center(child: Text(AppConstants.noDataFound));
        }

        // SUCCESS
        return _buildBody(
          context,
          controller,
          controller.blink.value!,
          controller.relatedTopics,
        );
      }),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PostDetailController controller,
    PostDetailModel post,
    List<RelatedTopic> relatedTopics,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AVATAR
                CircleAvatar(
                  radius: 22,
                  backgroundImage: post.author.profileImage.isNotEmpty
                      ? NetworkImage(post.author.profileImage)
                      : null,
                  backgroundColor: Colors.grey.shade300,
                  child: post.author.profileImage.isEmpty
                      ? const Icon(Icons.person, size: 22, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NAME + VERIFIED
                      Row(
                        children: [
                          Text(
                            post.author.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (post.author.isVerified) ...[
                            Image.asset(
                              CommonUi.setPngIcon("verified"),
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              AppConstants.verified,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 1),
                      // TIME + LOCATION
                      Text(
                        "${_timeAgo(post.createdAt)} · ${post.locationName}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // CONTENT
                      Text(post.content, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      // HASHTAG
                      Text(
                        "#${post.topic.name}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // IMAGE
                      if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            post.imageUrl!,
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;

                              return ShimmerLoader(
                                height: 260,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(14),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _actionChip(
                            Icons.favorite,
                            _formatCount(post.likeCount),
                            isActive: post.isLikedByMe,
                          ),
                          const SizedBox(width: 10),
                          _actionChip(
                            Icons.chat_bubble_outline,
                            _formatCount(post.commentCount),
                          ),
                          const SizedBox(width: 10),
                          _actionChip(
                            Icons.reply,
                            _formatCount(post.shareCount),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // RELATED TOPICS
            const Text(
              AppConstants.relatedTopics,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 0),

            if (relatedTopics.isNotEmpty)
              ...relatedTopics.asMap().entries.map((entry) {
                final index = entry.key;
                final topic = entry.value;
                return Column(
                  children: [
                    _topicTile(
                      "#${topic.name}",
                      "${topic.blinkCount} ${AppConstants.blinks}",
                    ),
                    if (index < relatedTopics.length - 1)
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: ColorConstants.dividerColor,
                      ),
                  ],
                );
              }).toList()
            else
              const Text(
                AppConstants.noRelatedTopics,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

            const SizedBox(height: 30),

            // BOTTOM BUTTONS
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) =>
                              ReportScreen(blinkId: controller.blinkId),
                        );
                      },
                      child: Container(
                        width: 215,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A73EA),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                CommonUi.setPngIcon("report"),
                                width: 8,
                                height: 14,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                AppConstants.reportThisBlinks,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // BLOCK BUTTON
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.isBlocking.value
                          ? null
                          : () => controller.blockUser(),
                      child: Container(
                        width: 149,
                        height: 44,
                        decoration: BoxDecoration(
                          color: controller.isBlocking.value
                              ? Colors.grey
                              : Colors.black87,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: controller.isBlocking.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      CommonUi.setPngIcon("block"),
                                      width: 12,
                                      height: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      AppConstants.blockUser,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  Widget _actionChip(IconData icon, String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD8DBDF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isActive ? Colors.red : null),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _topicTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
