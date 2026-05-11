import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/share_model.dart';
import '../services/share_services.dart';

enum SharePlatform { whatsapp, facebook, copyLink, instagram, twitter }

class ShareController extends GetxController {
  final ShareServices _services = ShareServices();

  // Observables
  final isSharing = false.obs;
  final isLoadingLinks = false.obs;
  final shareCount = 0.obs;
  final isShared = false.obs;
  final shareLinksModel = Rxn<ShareLinksModel>();
  final fetchError = ''.obs;
  final selectedFriendIndex = (-1).obs;

  // blinkId passed via constructor so it's ready BEFORE onInit fires
  final String blinkId;
  ShareController({required this.blinkId});

  // Lifecycle
  @override
  void onInit() {
    super.onInit();
    // shareCount from args if passed via Get.toNamed
    final args = Get.arguments;
    if (args is Map) {
      shareCount.value = args['shareCount'] ?? 0;
    }
    _fetchShareLinks();
  }

  // GET share-link
  Future<void> _fetchShareLinks() async {
    if (blinkId.isEmpty) return;
    isLoadingLinks.value = true;
    fetchError.value = '';

    try {
      final response = await _services.getShareLink(blinkId: blinkId);

      print("GetShareLink Response: ${response.success} | ${response.data}");

      if (response.success && response.data != null) {
        final data = response.data['data'];
        if (data['status'] == true) {
          shareLinksModel.value = ShareLinksModel.fromJson(
            data['shareLinks'] as Map<String, dynamic>,
          );
        } else {
          fetchError.value = data['message'] ?? 'Failed to get share link.';
        }
      } else {
        fetchError.value = response.message ?? 'Failed to fetch share link.';
      }
    } catch (e) {
      fetchError.value = 'Something went wrong. Please try again.';
      print("GetShareLink Error: $e");
    } finally {
      isLoadingLinks.value = false;
    }
  }

  Future<void> retryFetchShareLinks() => _fetchShareLinks();

  // POST share + launch platform URL
  Future<void> shareBlink(SharePlatform platform) async {
    if (isSharing.value || shareLinksModel.value == null) return;

    try {
      isSharing.value = true;

      // 1. Record the share on backend
      final response = await _services.shareBlink(blinkId: blinkId);

      print(
        "Share Response: ${response.success} | ${response.message} | ${response.data}",
      );

      if (response.success && response.data != null) {
        final innerData = response.data['data'];
        final model = ShareModel.fromJson(innerData);
        shareCount.value = model.shareCount;
        isShared.value = true;
        print("Share Count Updated: ${model.shareCount}");
      }

      await _launchPlatform(platform);
    } catch (e) {
      print("Share Error: $e");
    } finally {
      isSharing.value = false;
    }
  }

  // Platform launcher
  Future<void> _launchPlatform(SharePlatform platform) async {
    final links = shareLinksModel.value!;
    switch (platform) {
      case SharePlatform.whatsapp:
        await _launch(links.whatsapp);
        break;
      case SharePlatform.facebook:
        await _launch(links.facebook);
        break;
      case SharePlatform.copyLink:
        await _copyLink(links.copyLink);
        break;
      case SharePlatform.instagram:
        await _instagramFlow(links.instagram);
        break;
      case SharePlatform.twitter:
        await _launch(links.twitter);
        break;
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showError('Could not open the app. Please try again.');
    }
  }

  Future<void> _copyLink(String url) async {
    print("COPY LINK URL: $url");
    await Clipboard.setData(ClipboardData(text: url));
    Get.back();
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.snackbar(
        "Copied!",
        "Link copied to clipboard",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    });
  }

  Future<void> _instagramFlow(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    final igUri = Uri.parse('instagram://app');
    if (await canLaunchUrl(igUri)) {
      Get.snackbar(
        'Link Copied',
        'Paste it in your Instagram story or bio!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: Icon(Icons.camera_alt, color: Colors.pinkAccent),
      );
      await Future.delayed(const Duration(milliseconds: 900));
      await launchUrl(igUri, mode: LaunchMode.externalApplication);
    } else {
      await _copyLink(url);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
