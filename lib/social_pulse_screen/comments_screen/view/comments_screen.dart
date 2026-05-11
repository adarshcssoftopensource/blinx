import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/comments_controller.dart';
import '../model/comments_model.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentsController());

    return Scaffold(
      backgroundColor: ColorConstants.white,

      // APPBAR
      appBar: AppBar(
        surfaceTintColor: ColorConstants.white,

        backgroundColor: ColorConstants.white,

        elevation: 0,

        centerTitle: true,

        title: const MediumText(
          text: AppConstants.comments,

          fontWeight: FontWeight.w500,
        ),

        leading: GestureDetector(
          onTap: () => Get.back(),

          child: Padding(
            padding: const EdgeInsets.only(left: 0),

            child: Center(
              child: SizedBox(
                width: 16,

                height: 16,

                child: Image.asset(
                  CommonUi.setPngIcon("left_vector"),

                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),

      // BODY
      body: Column(
        children: [
          _postPreview(controller),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,

            height: 1,

            color: ColorConstants.dividerColor,
          ),

          const SizedBox(height: 3),

          // COMMENTS LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.comments.isEmpty) {
                return const Center(
                  child: Text(
                    AppConstants.noCommentsYet,

                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.comments.length,

                itemBuilder: (context, index) {
                  return _commentItem(controller.comments[index], controller);
                },
              );
            }),
          ),

          _commentInput(controller),
        ],
      ),
    );
  }

  Widget _postPreview(CommentsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  border: Border.all(
                    color: ColorConstants.postBorderColor,

                    width: 1.5,
                  ),
                ),

                child: Obx(() {
                  final image = controller.userProfileImage.value;

                  return CircleAvatar(
                    radius: 20,

                    backgroundColor: Colors.grey.shade300,

                    backgroundImage: image.isNotEmpty
                        ? NetworkImage(image)
                        : null,

                    child: image.isEmpty
                        ? const Icon(Icons.person, size: 18, color: Colors.grey)
                        : null,
                  );
                }),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Obx(
                      () => LargeText(
                        text: controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : AppConstants.user,

                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Obx(
                      () => SmallText(
                        text: _timeAgo(controller.postCreatedAt.value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 0),

          Padding(
            padding: const EdgeInsets.only(left: 55, right: 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Obx(() => SmallText(text: controller.postContent.value)),

                const SizedBox(height: 4),

                Obx(
                  () => controller.topicName.value.isNotEmpty
                      ? SmallText(
                          text: "#${controller.topicName.value}",

                          color: ColorConstants.buttonColor,

                          fontFamily: Fonts.interMedium,

                          fontWeight: FontWeight.w500,
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // LIKE BUTTON
          Padding(
            padding: const EdgeInsets.only(left: 55),

            child: Obx(
              () => GestureDetector(
                onTap: () => controller.toggleLike(),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(
                      controller.isLiked.value
                          ? Icons.favorite
                          : Icons.favorite_border,

                      size: 16,

                      color: controller.isLiked.value
                          ? Colors.red
                          : Colors.grey,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      controller.likeCount.value.toString(),

                      style: const TextStyle(
                        fontSize: 12,

                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      controller.isLiked.value
                          ? AppConstants.liked
                          : AppConstants.like,

                      style: TextStyle(
                        fontSize: 12,

                        fontWeight: FontWeight.w500,

                        color: controller.isLiked.value
                            ? ColorConstants.buttonColor
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _commentItem(CommentsModel comment, CommentsController controller) {
    return GestureDetector(
      onLongPress: () {
        Get.defaultDialog(
          title: AppConstants.deleteComment,

          middleText: AppConstants.areYouSureDeleteComment,

          cancelTextColor: ColorConstants.buttonColor,

          textConfirm: AppConstants.delete,

          textCancel: AppConstants.cancel,

          confirmTextColor: Colors.white,

          buttonColor: ColorConstants.blueColor,

          onConfirm: () {
            Get.back();

            controller.deleteComment(comment.id);
          },
        );
      },

      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CircleAvatar(
              radius: 16,

              backgroundImage: comment.author.profileImage.isNotEmpty
                  ? NetworkImage(comment.author.profileImage)
                  : null,

              backgroundColor: Colors.grey.shade300,

              child: comment.author.profileImage.isEmpty
                  ? const Icon(Icons.person, size: 16, color: Colors.grey)
                  : null,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 309,

                      minHeight: 51,
                    ),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,

                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: ColorConstants.commentBubbleColor,

                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  MediumText(text: comment.author.name),

                                  if (comment.author.isVerified) ...[
                                    const SizedBox(width: 4),

                                    const Icon(
                                      Icons.verified,

                                      size: 12,

                                      color: ColorConstants.verifiedIconColor,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            const SizedBox(width: 6),

                            SmallText(text: _timeAgo(comment.createdAt)),
                          ],
                        ),

                        const SizedBox(height: 4),

                        SmallText(text: comment.content),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleCommentLike(comment.id),

                        child: Obx(() {
                          final isCommentLiked =
                              controller.commentLikes[comment.id] ?? false;

                          return Text(
                            isCommentLiked
                                ? AppConstants.liked
                                : AppConstants.like,

                            style: TextStyle(
                              fontSize: 13,

                              fontWeight: FontWeight.w500,

                              color: isCommentLiked
                                  ? Colors.red
                                  : ColorConstants.buttonColor,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(width: 13),

                      GestureDetector(
                        onTap: () => controller.setReplyTo(comment),

                        child: const MediumText(
                          text: AppConstants.reply,

                          fontSize: 12,

                          color: ColorConstants.buttonColor,
                        ),
                      ),
                    ],
                  ),

                  // REPLIES
                  if (comment.replies.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 32, top: 6),

                      child: Column(
                        children: comment.replies.map((reply) {
                          return GestureDetector(
                            onLongPress: () {
                              Get.defaultDialog(
                                title: AppConstants.deleteReply,

                                middleText: AppConstants.areYouSureDeleteReply,

                                textConfirm: AppConstants.delete,

                                textCancel: AppConstants.cancel,

                                confirmTextColor: Colors.white,

                                buttonColor: ColorConstants.blueColor,

                                onConfirm: () {
                                  Get.back();

                                  controller.deleteReply(
                                    commentId: comment.id,

                                    replyId: reply.id,
                                  );
                                },
                              );
                            },

                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 6),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  CircleAvatar(
                                    radius: 12,

                                    backgroundImage:
                                        reply.author.profileImage.isNotEmpty
                                        ? NetworkImage(
                                            reply.author.profileImage,
                                          )
                                        : null,

                                    backgroundColor: Colors.grey.shade300,

                                    child: reply.author.profileImage.isEmpty
                                        ? const Icon(
                                            Icons.person,

                                            size: 12,

                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,

                                        vertical: 6,
                                      ),

                                      decoration: BoxDecoration(
                                        color:
                                            ColorConstants.commentBubbleColor,

                                        borderRadius: BorderRadius.circular(8),
                                      ),

                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Row(
                                            children: [
                                              MediumText(
                                                text: reply.author.name,

                                                fontSize: 12,
                                              ),

                                              if (reply.author.isVerified) ...[
                                                const SizedBox(width: 4),

                                                const Icon(
                                                  Icons.verified,

                                                  size: 10,

                                                  color: ColorConstants
                                                      .verifiedIconColor,
                                                ),
                                              ],

                                              const Spacer(),

                                              SmallText(
                                                text: _timeAgo(reply.createdAt),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 2),

                                          SmallText(text: reply.content),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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

  Widget _commentInput(CommentsController controller) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 16, 16, 18),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Obx(() {
              if (controller.replyingTo.value == null) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 4),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${AppConstants.replyingTo}${controller.replyingTo.value!.author.name}!",

                        style: const TextStyle(
                          fontSize: 12,

                          fontWeight: FontWeight.w500,

                          color: Colors.black,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => controller.replyingTo.value = null,

                      child: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ),
              );
            }),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,

                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    decoration: BoxDecoration(
                      color: ColorConstants.commentBubbleColor,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Center(
                      child: TextField(
                        controller: controller.commentController,

                        maxLines: 1,

                        style: const TextStyle(fontSize: 13),

                        decoration: const InputDecoration(
                          hintText: AppConstants.writeYourMessage,

                          hintStyle: TextStyle(fontSize: 14),

                          border: InputBorder.none,

                          isDense: true,

                          contentPadding: EdgeInsets.zero,
                        ),

                        onSubmitted: (_) => controller.addComment(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Obx(
                  () => GestureDetector(
                    onTap: controller.isSending.value
                        ? null
                        : () => controller.addComment(),

                    child: controller.isSending.value
                        ? const SizedBox(
                            width: 24,

                            height: 24,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.send, color: ColorConstants.blueColor),
                  ),
                ),
              ],
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

      if (diff.inMinutes < 1) return AppConstants.justNow;

      if (diff.inMinutes < 60)
        return "${diff.inMinutes}${AppConstants.minuteAgo}";

      if (diff.inHours < 24) return "${diff.inHours}${AppConstants.hourAgo}";

      if (diff.inDays < 7) return "${diff.inDays}${AppConstants.dayAgo}";

      if (diff.inDays < 30)
        return "${(diff.inDays / 7).floor()}${AppConstants.weekAgo}";

      if (diff.inDays < 365) return "${(diff.inDays / 30).floor()}mo ago";

      return "${(diff.inDays / 365).floor()}y ago";
    } catch (e) {
      return AppConstants.empty;
    }
  }
}
