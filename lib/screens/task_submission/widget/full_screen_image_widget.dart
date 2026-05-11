import 'dart:io';

import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controller/task_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class TaskSubmission1Screen extends StatelessWidget {
  final String applicationId;

  const TaskSubmission1Screen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TaskSubmission1ScreenController(applicationId: applicationId),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 15,
            width: 15,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          AppConstants.taskSubmission,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskCard(),
            const SizedBox(height: 10),
            const Text(
              AppConstants.definitionOfDone,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const Text(
              AppConstants.dodPlaceholder,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              AppConstants.proofOfWork,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bigInputBox(controller),
                Obx(
                  () => controller.descriptionError.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 6, left: 8),
                          child: Text(
                            controller.descriptionError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              AppConstants.uploadPhotos,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotosBox(controller, context),
                Obx(
                  () => controller.photosError.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 6, left: 8),
                          child: Text(
                            controller.photosError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              AppConstants.uploadVideoOptional,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildVideoBox(controller, context),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 176,
                height: 50,
                child: Obx(
                  () => controller.taskController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () => controller.onSubmit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A73EA),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            AppConstants.submitWork,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _taskCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3478F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  AppConstants.statusOpen,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  AppConstants.dueIn2d,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            AppConstants.cleanupTaskTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            AppConstants.creditsEcoWarrior,
            style: TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  static Widget _bigInputBox(TaskSubmission1ScreenController controller) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller.descriptionController,
        maxLines: null,
        decoration: const InputDecoration.collapsed(
          hintText: AppConstants.proofHint,
          hintStyle: TextStyle(color: Colors.black38),
        ),
      ),
    );
  }

  static Widget _buildPhotosBox(
    TaskSubmission1ScreenController controller,
    BuildContext context,
  ) {
    return Obx(() {
      if (controller.photos.isEmpty) {
        return GestureDetector(
          onTap: () => controller.showMediaSourceSheet(context, isPhoto: true),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    CommonUi.setPngIcon("image"),
                    width: 21,
                    height: 21,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    AppConstants.addImage,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      int totalPages = (controller.photos.length / 2).ceil();

      return Stack(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: cs.CarouselSlider.builder(
                itemCount: totalPages,
                itemBuilder: (context, index, realIndex) {
                  final firstIndex = index * 2;
                  final secondIndex = firstIndex + 1;
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openFullScreenImage(
                            context,
                            File(controller.photos[firstIndex].path),
                          ),
                          onLongPress: () =>
                              controller.removePhotoAt(firstIndex),
                          child: Image.file(
                            File(controller.photos[firstIndex].path),
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        ),
                      ),
                      if (secondIndex < controller.photos.length)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _openFullScreenImage(
                              context,
                              File(controller.photos[secondIndex].path),
                            ),
                            onLongPress: () =>
                                controller.removePhotoAt(secondIndex),
                            child: Image.file(
                              File(controller.photos[secondIndex].path),
                              fit: BoxFit.cover,
                              height: 150,
                            ),
                          ),
                        ),
                    ],
                  );
                },
                options: cs.CarouselOptions(
                  height: 150,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (i, r) => controller.carouselIndex.value = i,
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Text(
                  '${controller.carouselIndex.value + 1}/$totalPages',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
          if (controller.photos.length <
              TaskSubmission1ScreenController.maxPhotos)
            Positioned(
              left: 70,
              bottom: 8,
              child: GestureDetector(
                onTap: () =>
                    controller.showMediaSourceSheet(context, isPhoto: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Add', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                final deleteFirst = controller.carouselIndex.value * 2;
                if (deleteFirst < controller.photos.length)
                  controller.removePhotoAt(deleteFirst);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    });
  }

  static Widget _buildVideoBox(
    TaskSubmission1ScreenController controller,
    BuildContext context,
  ) {
    return Obx(() {
      if (controller.video.value == null) {
        return GestureDetector(
          onTap: () => controller.showMediaSourceSheet(context, isPhoto: false),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  CommonUi.setPngIcon("video"),
                  width: 30,
                  height: 30,
                ),
                const SizedBox(height: 8),
                const Text(
                  AppConstants.tapSelectVideo,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      }

      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.black12,
              ),
              child:
                  controller.videoController.value != null &&
                      controller.videoController.value!.value.isInitialized
                  ? GestureDetector(
                      onTap: () async {},
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: controller
                                .videoController
                                .value!
                                .value
                                .aspectRatio,
                            child: VideoPlayer(
                              controller.videoController.value!,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.grey),
                    ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: controller.removeVideo,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    });
  }

  static void _openFullScreenImage(BuildContext context, File file) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FullScreenImageViewer(imageFile: file)),
    );
  }
}

// ─── Full Screen Image Viewer (already StatelessWidget — unchanged) ────────────

class FullScreenImageViewer extends StatelessWidget {
  final File imageFile;
  const FullScreenImageViewer({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.file(imageFile, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black45,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
