import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/post_detail_model.dart';
import '../services/post_detail_services.dart';

class PostDetailController extends GetxController {
  final PostDetailServices _services = PostDetailServices();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final blink = Rxn<PostDetailModel>();
  final relatedTopics = <RelatedTopic>[].obs;
  final isBlocking = false.obs;

  final String blinkId;
  PostDetailController({required this.blinkId});

  @override
  void onInit() {
    super.onInit();

    print("BlinkId received: $blinkId");

    if (blinkId.isNotEmpty) {
      fetchDetail();
    } else {
      errorMessage.value = "Invalid blink link";
    }
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _services.getBlinkDetail(blinkId: blinkId);

      if (response.success && response.data != null) {
        final data = response.data['data'];

        blink.value = PostDetailModel.fromJson(data['blink']);

        final List rawTopics = data['relatedTopics'] ?? [];
        relatedTopics.value = rawTopics
            .map((e) => RelatedTopic.fromJson(e))
            .toList();
      } else {
        errorMessage.value = response.message ?? "Failed to load detail";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong";
      print("Post Detail Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> blockUser() async {
    if (isBlocking.value) return;
    if (blink.value == null) return;

    try {
      isBlocking.value = true;

      final userId = blink.value!.author.id;
      print("Blocking userId: $userId");

      final response = await _services.blockUser(userId: userId);

      print(
        "Block Response: success=${response.success} | msg=${response.message} | data=${response.data}",
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          response.success ? "Blocked" : "Error",
          response.message ??
              (response.success
                  ? "User blocked successfully"
                  : "Failed to block user"),
          backgroundColor: response.success ? Colors.green : Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      });
    } catch (e, stack) {
      print("Block Error: $e");
      print("Block StackTrace: $stack");
    } finally {
      isBlocking.value = false;
    }
  }
}
