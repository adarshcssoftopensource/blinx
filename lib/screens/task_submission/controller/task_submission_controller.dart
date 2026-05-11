import 'dart:io';

import 'package:blinx_mobile/screens/my_submission/view/my_submission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../business_logic/store_services.dart';
import '../services/task_submission1_service.dart';

class TaskSubmissionController extends GetxController {
  final String applicationId;

  TaskSubmissionController({required this.applicationId});

  final TaskSubmissionService service = TaskSubmissionService();

  // ─── Constants ───────────────────────────────────────────────────────────────
  static const int maxPhotos = 6;

  // ─── Text Controllers ─────────────────────────────────────────────────────────
  final TextEditingController descriptionController = TextEditingController();

  // Reactive state variables for loading status, success flag and response message
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final responseMessage = ''.obs;

  // ─── Validation Errors ────────────────────────────────────────────────────────
  final descriptionError = ''.obs;
  final photosError = ''.obs;

  // ─── Media State ──────────────────────────────────────────────────────────────
  final photos = <XFile>[].obs;
  final video = Rx<XFile?>(null);
  final videoController = Rx<VideoPlayerController?>(null);
  final carouselIndex = 0.obs;

  // ─── Lifecycle ────────────────────────────────────────────────────────────────
  @override
  void onClose() {
    descriptionController.dispose();
    videoController.value?.dispose();
    super.onClose();
  }

  // ─── Media Source Sheet ───────────────────────────────────────────────────────
  void showMediaSourceSheet(BuildContext context, {required bool isPhoto}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                isPhoto
                    ? _pickPhoto(ImageSource.camera)
                    : _pickVideo(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                isPhoto
                    ? _pickPhoto(ImageSource.gallery)
                    : _pickVideo(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Photo Picking ────────────────────────────────────────────────────────────
  Future<void> _pickPhoto(ImageSource source) async {
    if (photos.length >= maxPhotos) {
      Get.snackbar('Limit reached', 'Maximum $maxPhotos photos allowed');
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      photos.add(picked);
      photosError.value = '';
    }
  }

  void removePhotoAt(int index) {
    if (index < photos.length) {
      photos.removeAt(index);
      final totalPages = (photos.length / 2).ceil();
      if (carouselIndex.value >= totalPages && carouselIndex.value > 0) {
        carouselIndex.value = totalPages - 1;
      }
    }
  }

  // ─── Video Picking ────────────────────────────────────────────────────────────
  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: source);
    if (picked != null) {
      video.value = picked;
      await _initVideoController(picked.path);
    }
  }

  Future<void> _initVideoController(String path) async {
    videoController.value?.dispose();
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    videoController.value = controller;
  }

  void removeVideo() {
    videoController.value?.dispose();
    videoController.value = null;
    video.value = null;
  }

  // ─── Validation ───────────────────────────────────────────────────────────────
  bool _validate() {
    bool valid = true;
    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = 'Please describe your proof of work';
      valid = false;
    } else {
      descriptionError.value = '';
    }
    if (photos.isEmpty) {
      photosError.value = 'Please upload at least one photo';
      valid = false;
    } else {
      photosError.value = '';
    }
    return valid;
  }

  // ─── On Submit (called by screen) ─────────────────────────────────────────────
  Future<void> onSubmit(BuildContext context) async {
    if (!_validate()) return;

    await submitTask(
      applicationId: applicationId,
      description: descriptionController.text.trim(),
      photos: photos.map((e) => File(e.path)).toList(),
      videoFile: video.value != null ? File(video.value!.path) : null,
    );
  }

  Future<bool> submitTask({
    required String description,
    File? videoFile,
    List<File>? photos,
    String? token,
    required String applicationId,
  }) async {
    try {
      isLoading.value = true;
      isSuccess.value = false;
      responseMessage.value = '';

      // Uses provided token or falls back to fetching stored access token
      final accessToken = token ?? await StoreServices.getAccessToken();

      // Aborts submission and shows error if no valid token is found
      if (accessToken == null || accessToken.isEmpty) {
        _showSnack('', 'Unauthorized', Colors.red);
        return false;
      }

      // Calls the services to submit work with all provided files and metadata
      final response = await service.submitWork(
        applicationId: applicationId,
        description: description,
        videoFile: videoFile,
        photos: photos,
        token: accessToken,
      );

      isSuccess.value = response.success;
      responseMessage.value = response.message;

      // Shows green snackbar on success and red on failure
      _showSnack(
        '',
        response.message,
        response.success ? Colors.green : Colors.red,
        isError: !response.success,
      );

      return response.success;
    } catch (e) {
      debugPrint('Submit task error => $e');
      _showSnack('', 'Upload failed, please try again', Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Displays a floating snackbar with dynamic color and success/failed label
  void _showSnack(
    String title,
    String message,
    Color color, {
    bool isError = true,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      snackStyle: SnackStyle.FLOATING,
      titleText: const SizedBox.shrink(),
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isError ? 'Failed' : 'Success',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Text(
            message,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> submitTaskApi(
    dynamic postData, {
    required String applicationId,
  }) async {
    try {
      isLoading.value = true;

      // Calls the multipart API services and waits for the submission response
      final response = await service.submitTaskApiService(
        postData,
        applicationId: applicationId,
      );

      // Navigates to MySubmissionScreen on success, shows error snackbar on failure
      if (response.success) {
        Get.to(MySubmissionScreen());
      } else {
        Get.snackbar("Failed", response.message);
      }
    } catch (e) {
      debugPrint('Submit task api error => $e');
    } finally {
      isLoading.value = false;
    }
  }
}
