import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/comments_model.dart';
import '../services/comments_services.dart';

class CommentsController extends GetxController {
  final CommentsServices _services = CommentsServices();

  RxString postCreatedAt = "".obs;
  RxString postContent = "".obs;
  RxString topicName = "".obs;
  Rx<CommentsModel?> replyingTo = Rx<CommentsModel?>(null);

  final comments = <CommentsModel>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;

  // Post like state
  final isLiked = false.obs;
  final likeCount = 0.obs;

  final commentLikes = <String, bool>{}.obs;

  final userName = ''.obs;
  final userProfileImage = ''.obs;

  final commentController = TextEditingController();

  late String blinkId;

  void setReplyTo(CommentsModel comment) {
    replyingTo.value = comment;
  }

  void _showSnackbar(String title, String message, Color bgColor) {
    Future.delayed(Duration.zero, () {
      Get.snackbar(
        title,
        message,
        backgroundColor: bgColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  @override
  void onInit() {
    super.onInit();
    // postCreatedAt.value = args['createdAt'] ?? '';

    userProfileImage.value = AuthController.to.profileImage.value;

    _loadUserName();

    final args = Get.arguments;
    if (args is Map) {
      blinkId = args['blinkId'] ?? '';
      isLiked.value = args['isLiked'] ?? false;
      likeCount.value = args['likeCount'] ?? 0;
      postContent.value = args['content'] ?? '';
      topicName.value = args['topicName'] ?? '';
      postCreatedAt.value = args['createdAt'] ?? '';
    } else {
      blinkId = args ?? '';
    }

    if (blinkId.isNotEmpty) {
      fetchComments();
    }
  }

  Future<void> _loadUserName() async {
    final name = await StoreServices.getUserName() ?? '';
    userName.value = name;
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  // GET comments
  Future<void> fetchComments() async {
    try {
      isLoading.value = true;
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await _services.getComments(
        token: token,
        blinkId: blinkId,
      );

      if (response.success && response.data != null) {
        final apiContent =
            response.data!['blink']?['content'] ??
            response.data!['data']?['content'];
        final apiTopic =
            response.data!['blink']?['topic']?['name'] ??
            response.data!['data']?['topic']?['name'];

        if (apiContent != null) postContent.value = apiContent;
        if (apiTopic != null) topicName.value = apiTopic;

        final List raw = response.data!['comments'] ?? [];
        comments.value = raw.map((e) => CommentsModel.fromJson(e)).toList();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // POST add comment
  Future<void> addComment() async {
    final content = commentController.text.trim();
    if (content.isEmpty) return;

    try {
      isSending.value = true;
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final replyTarget = replyingTo.value;

      if (replyTarget != null) {
        final response = await _services.addReply(
          token: token,
          blinkId: blinkId,
          commentId: replyTarget.id,
          content: content,
        );

        if (response.success && response.data != null) {
          final newReply = CommentsModel.fromJson(response.data!['reply']);
          final index = comments.indexWhere((c) => c.id == replyTarget.id);
          if (index != -1) {
            final parent = comments[index];
            final updatedReplies = [...parent.replies, newReply];
            comments[index] = CommentsModel(
              id: parent.id,
              content: parent.content,
              createdAt: parent.createdAt,
              author: parent.author,
              replies: updatedReplies,
            );
            comments.refresh();
          }
          replyingTo.value = null;
          commentController.clear();
        } else {
          _showSnackbar(
            "Error",
            response.message ?? "Failed to add reply",
            Colors.red,
          );
        }
      } else {
        final response = await _services.addComment(
          token: token,
          blinkId: blinkId,
          content: content,
        );

        if (response.success && response.data != null) {
          final newComment = CommentsModel.fromJson(response.data!['comment']);
          comments.insert(0, newComment);
          commentController.clear();
        } else {
          _showSnackbar(
            "Error",
            response.message ?? "Failed to add comment",
            Colors.red,
          );
        }
      }
    } catch (e) {
      _showSnackbar("Error", e.toString(), Colors.red);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteReply({
    required String commentId,
    required String replyId,
  }) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await _services.deleteReply(
        token: token,
        blinkId: blinkId,
        commentId: commentId,
        replyId: replyId,
      );

      if (response.success) {
        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          final parent = comments[index];
          final updatedReplies = parent.replies
              .where((r) => r.id != replyId)
              .toList();
          comments[index] = CommentsModel(
            id: parent.id,
            content: parent.content,
            createdAt: parent.createdAt,
            author: parent.author,
            replies: updatedReplies,
          );
          comments.refresh();
        }
        _showSnackbar("Deleted", "Reply deleted", Colors.green);
      } else {
        _showSnackbar(
          "Error",
          response.message ?? "Failed to delete reply",
          Colors.red,
        );
      }
    } catch (e) {}
  }

  // DELETE comment
  Future<void> deleteComment(String commentId) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await _services.deleteComment(
        token: token,
        blinkId: blinkId,
        commentId: commentId,
      );

      if (response.success) {
        // comments.removeWhere((c) => c.id == commentId);
        comments.removeWhere((c) => c.id == commentId);
        comments.refresh();
        commentLikes.remove(commentId);
        commentLikes.remove(commentId);
        _showSnackbar("Deleted", "Comment deleted", Colors.green);
      } else {
        _showSnackbar(
          "Error",
          response.message ?? "Failed to delete",
          Colors.red,
        );
      }
    } catch (e) {}
  }

  // POST toggle post like
  Future<void> toggleLike() async {
    isLiked.value = !isLiked.value;
    likeCount.value = isLiked.value ? likeCount.value + 1 : likeCount.value - 1;

    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final response = await _services.toggleLike(
        token: token,
        blinkId: blinkId,
      );

      if (response.success && response.data != null) {
        isLiked.value = response.data!['liked'] ?? isLiked.value;
        likeCount.value = response.data!['likeCount'] ?? likeCount.value;
      } else {
        // Revert
        isLiked.value = !isLiked.value;
        likeCount.value = isLiked.value
            ? likeCount.value + 1
            : likeCount.value - 1;
      }
    } catch (e) {
      isLiked.value = !isLiked.value;
      likeCount.value = isLiked.value
          ? likeCount.value + 1
          : likeCount.value - 1;
    }
  }

  void toggleCommentLike(String commentId) {
    final current = commentLikes[commentId] ?? false;
    commentLikes[commentId] = !current;
  }
}
