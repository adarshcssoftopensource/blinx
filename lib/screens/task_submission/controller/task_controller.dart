import 'dart:io';

import 'package:blinx_mobile/screens/task_submission/controller/task_submission_controller.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../my_submission/view/my_submission.dart';

// ─── Controller ───────────────────────────────────────────────────────────────

class TaskSubmission1ScreenController extends GetxController {
  final String applicationId;

  TaskSubmission1ScreenController({required this.applicationId});

  static const int maxPhotos = 5;
  final ImagePicker _picker = ImagePicker();

  final RxList<XFile> photos = <XFile>[].obs;
  final Rx<XFile?> video = Rx<XFile?>(null);
  final Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(
    null,
  );

  final RxString descriptionError = ''.obs;
  final RxString photosError = ''.obs;
  final RxInt carouselIndex = 0.obs;

  final TextEditingController descriptionController = TextEditingController();
  late final TaskSubmissionController taskController;

  @override
  void onInit() {
    super.onInit();
    taskController = Get.put(
      TaskSubmissionController(applicationId: applicationId),
    );
  }

  @override
  void onClose() {
    videoController.value?.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // ── Photo picking ──────────────────────────────────────────────────────────

  Future<void> pickImagesFromGallery() async {
    try {
      final List<XFile>? picked = await _picker.pickMultiImage();
      if (picked == null || picked.isEmpty) return;
      final spaceLeft = maxPhotos - photos.length;
      photos.addAll(picked.take(spaceLeft));
    } catch (e) {
      debugPrint('pickMultiImage error: $e');
    }
  }

  Future<void> pickImageFromCamera(BuildContext context) async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked == null) return;
      if (photos.length >= maxPhotos) {
        _showSnack(context, AppConstants.maxPhotosReached);
        return;
      }
      photos.add(picked);
    } catch (e) {
      debugPrint('pickImage camera error: $e');
    }
  }

  Future<void> pickVideoFromGallery(BuildContext context) async {
    try {
      final XFile? picked = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (picked == null) return;
      await setVideo(picked, context);
    } catch (e) {
      debugPrint('pickVideo gallery error: $e');
    }
  }

  Future<void> pickVideoFromCamera(BuildContext context) async {
    try {
      final XFile? picked = await _picker.pickVideo(source: ImageSource.camera);
      if (picked == null) return;
      await setVideo(picked, context);
    } catch (e) {
      debugPrint('pickVideo camera error: $e');
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void showMediaSourceSheet(BuildContext context, {required bool isPhoto}) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text(AppConstants.camera),
              onTap: () {
                Navigator.pop(ctx);
                isPhoto
                    ? pickImageFromCamera(context)
                    : pickVideoFromCamera(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text(AppConstants.gallery),
              onTap: () {
                Navigator.pop(ctx);
                isPhoto
                    ? pickImagesFromGallery()
                    : pickVideoFromGallery(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void removePhotoAt(int index) {
    photos.removeAt(index);
    if (carouselIndex.value >= photos.length) {
      carouselIndex.value = photos.isEmpty ? 0 : photos.length - 1;
    }
  }

  Future<void> removeVideo() async {
    await videoController.value?.pause();
    await videoController.value?.dispose();
    video.value = null;
    videoController.value = null;
  }

  Future<void> setVideo(XFile file, BuildContext context) async {
    final originalFile = File(file.path);
    debugPrint(
      "Original video size (MB): ${(originalFile.lengthSync() / (1024 * 1024)).toStringAsFixed(2)}",
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
      file.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );

    if (context.mounted) Navigator.pop(context);

    if (compressedVideo == null || compressedVideo.file == null) {
      _showSnack(context, AppConstants.videoCompressionFailed);
      return;
    }

    final compressedFile = compressedVideo.file!;
    debugPrint(
      "Compressed video size (MB): ${(compressedFile.lengthSync() / (1024 * 1024)).toStringAsFixed(2)}",
    );

    await videoController.value?.dispose();

    final vc = VideoPlayerController.file(compressedFile);
    await vc.initialize();

    video.value = XFile(compressedFile.path);
    videoController.value = vc;
    carouselIndex.value = 0;

    debugPrint("Video compressed & controller initialized");
  }

  Future<void> onSubmit(BuildContext context) async {
    descriptionError.value = '';
    photosError.value = '';

    bool hasError = false;

    if (descriptionController.text.trim().isEmpty) {
      descriptionError.value = AppConstants.fieldRequired;
      hasError = true;
    }
    if (photos.isEmpty) {
      photosError.value = AppConstants.atLeastOnePhoto;
      hasError = true;
    }
    if (hasError) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    bool success = await taskController.submitTask(
      applicationId: applicationId,
      description: descriptionController.text.trim(),
      photos: photos.map((x) => File(x.path)).toList(),
      videoFile: video.value != null ? File(video.value!.path) : null,
    );

    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MySubmissionScreen()),
      );
    }
  }
}
