import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/home_screen_model.dart';
import '../services/home_screen_services.dart';

class HomeScreenController extends GetxController {
  final HomeScreenServices services = HomeScreenServices();

  final isLoading = false.obs;
  final blinks = <HomeScreenModel>[].obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalCount = 0.obs;
  final hasError = false.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeed();
  }

  Future<void> fetchFeed({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        blinks.clear();
      }

      if (isLoading.value && !isRefresh) return;
      isLoading.value = true;
      hasError.value = false;

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) throw "No access token found";

      final response = await services.getFeed(
        token: token,
        page: currentPage.value,
      );

      if (response.success) {
        if (isRefresh) {
          blinks.assignAll(response.blinks);
        } else {
          blinks.addAll(response.blinks);
        }
        currentPage.value = response.currentPage;
        totalPages.value = response.totalPages;
        totalCount.value = response.totalCount;
      } else {
        Get.snackbar(
          "Failed",
          response.message ?? "Failed to load feed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("HomeScreenController Error: $e");
      hasError.value = true;
      Get.snackbar(
        "Failed",
        "No Internet, please check your internet connection",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFeed() async {
    await fetchFeed(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      await fetchFeed();
    }
  }

  Future<void> toggleLike(String blinkId) async {
    final index = blinks.indexWhere((b) => b.id == blinkId);
    if (index == -1) return;

    final blink = blinks[index];
    final wasLiked = blink.isLikedByMe;

    blinks[index] = HomeScreenModel(
      id: blink.id,
      content: blink.content,
      imageUrl: blink.imageUrl,
      visibility: blink.visibility,
      status: blink.status,
      latitude: blink.latitude,
      longitude: blink.longitude,
      locationName: blink.locationName,
      likeCount: wasLiked ? blink.likeCount - 1 : blink.likeCount + 1,
      commentCount: blink.commentCount,
      shareCount: blink.shareCount,
      createdAt: blink.createdAt,
      topic: blink.topic,
      author: blink.author,
      isLikedByMe: !wasLiked,
    );

    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) return;

      final result = await services.toggleLike(token: token, blinkId: blinkId);

      if (result['success'] == true) {
        blinks[index] = HomeScreenModel(
          id: blink.id,
          content: blink.content,
          imageUrl: blink.imageUrl,
          visibility: blink.visibility,
          status: blink.status,
          latitude: blink.latitude,
          longitude: blink.longitude,
          locationName: blink.locationName,
          likeCount: result['likeCount'] ?? blinks[index].likeCount,
          commentCount: blink.commentCount,
          shareCount: blink.shareCount,
          createdAt: blink.createdAt,
          topic: blink.topic,
          author: blink.author,
          isLikedByMe: result['liked'] ?? blinks[index].isLikedByMe,
        );
      } else {
        blinks[index] = blink;
      }
    } catch (e) {
      print("Toggle Like Error: $e");
      blinks[index] = blink;
    }
  }
}
