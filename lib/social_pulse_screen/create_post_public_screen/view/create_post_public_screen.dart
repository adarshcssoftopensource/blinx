import 'dart:io';

import 'package:blinx_mobile/map/blinx_map_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/create_post_public_screen/controller/create_post_public_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/draft_screen/view/draft_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/controller/home_screen_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/select_topic/model/select_topic_model.dart';
import 'package:blinx_mobile/social_pulse_screen/select_topic/view/select_topic_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/location_popup.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../home_screen/view/home_screen.dart';

class CreatePostPublicScreen extends StatelessWidget {
  const CreatePostPublicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreatePostPublicController controller = Get.put(
      CreatePostPublicController(),
    );

    final TextEditingController contentController = TextEditingController();

    final Rx<File?> selectedImage = Rx<File?>(null);
    final RxBool isUrgent = false.obs;

    final ImagePicker picker = ImagePicker();

    final topic = Get.arguments;

    if (topic != null && topic is SelectTopicModel) {
      controller.selectedTopic.value = topic;
    }

    Future<void> openTopicSelection() async {
      final result = await Get.to(() => const SelectTopicScreen());

      if (result != null && result is SelectTopicModel) {
        controller.selectedTopic.value = result;
      }
    }

    void switchToPrivate() {
      Get.back(result: controller.selectedTopic.value);
    }

    Future<void> saveAsDraft() async {
      if (contentController.text.trim().isEmpty) {
        Get.snackbar(
          "Failed",
          "Please write something before saving as draft!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (controller.selectedTopic.value == null) {
        Get.snackbar(
          "Failed",
          "Please select a topic before saving as draft!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      await controller.saveAsDraft(
        content: contentController.text.trim(),
        topicId: controller.selectedTopic.value!.id,
        locationName: controller.locationName.value,
        latitude: controller.latitude.value,
        longitude: controller.longitude.value,
        isUrgent: isUrgent.value,
        image: selectedImage.value,
      );

      if (controller.isDraftSuccess.value) {
        Get.off(() => const DraftScreen());
      }
    }

    Future<void> publishPost() async {
      if (controller.selectedTopic.value == null) {
        Get.snackbar(
          "Failed",
          "Please select a topic before publishing!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (contentController.text.trim().isEmpty) {
        Get.snackbar(
          "Failed",
          "Please write something before publishing!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (contentController.text.trim().length > 500) {
        Get.snackbar(
          "Limit Exceeded",
          "Content cannot exceed 500 characters",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      await controller.createPublicBlink(
        content: contentController.text.trim(),
        topicId: controller.selectedTopic.value!.id,
        locationName: controller.locationName.value,
        latitude: controller.latitude.value,
        longitude: controller.longitude.value,
        isUrgent: isUrgent.value,
        image: selectedImage.value,
      );

      if (controller.isSuccess.value) {
        if (Get.isRegistered<HomeScreenController>()) {
          await Get.find<HomeScreenController>().fetchFeed(isRefresh: true);
        }

        Get.offAll(() => const HomeScreen());
      }
    }

    void showImagePickerSheet() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppConstants.selectImage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ListTile(
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: ColorConstants.lighterGreyColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                      title: const Text(AppConstants.takePhoto),
                      onTap: () async {
                        Navigator.pop(context);

                        final XFile? photo = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 80,
                        );

                        if (photo != null) {
                          selectedImage.value = File(photo.path);
                        }
                      },
                    ),

                    const Divider(height: 1),

                    ListTile(
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: ColorConstants.lighterGreyColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library_outlined),
                      ),
                      title: const Text(AppConstants.chooseFromGallery),
                      onTap: () async {
                        Navigator.pop(context);

                        final XFile? photo = await picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );

                        if (photo != null) {
                          selectedImage.value = File(photo.path);
                        }
                      },
                    ),

                    if (selectedImage.value != null) ...[
                      const Divider(height: 1),

                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                        title: const Text(
                          AppConstants.removeImage,
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          selectedImage.value = null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: Get.back,
                      child: const MediumText(text: AppConstants.cancel),
                    ),

                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 20,
                        backgroundImage: controller.userAvatar.value.isNotEmpty
                            ? NetworkImage(controller.userAvatar.value)
                            : null,
                        child: controller.userAvatar.value.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Obx(
                      () => MediumText(
                        text: controller.userName.value.isNotEmpty
                            ? controller.userName.value
                            : AppConstants.user,
                        fontFamily: Fonts.semiBold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: contentController,
                      maxLines: null,
                      maxLength: 500,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: "What do you want to talk about?",
                        hintStyle: TextStyle(
                          color: ColorConstants.hintText,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        counterText: "",
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(
                      () => GestureDetector(
                        onTap: showImagePickerSheet,
                        child: Container(
                          height: 190,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: selectedImage.value != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      selectedImage.value!,
                                      fit: BoxFit.cover,
                                    ),

                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: showImagePickerSheet,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    SmallText(
                                      text: "Image/Video Preview",
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: ColorConstants.lightCardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const LargeText(
                                text: AppConstants.postVisibility,
                                fontWeight: FontWeight.w600,
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: switchToPrivate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: const MediumText(
                                          text: "Private",
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorConstants.primaryBlue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const MediumText(
                                        text: "Public",
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: SmallText(
                              text:
                                  "The blink post will share publicly to everyone",
                              color: ColorConstants.lightGreyColor,
                            ),
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: openTopicSelection,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.work_outline),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Obx(
                                      () => LargeText(
                                        text:
                                            controller
                                                .selectedTopic
                                                .value
                                                ?.name ??
                                            "Select a Topic*",
                                      ),
                                    ),
                                  ),

                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                            ),
                          ),

                          Divider(color: Colors.grey.shade300),

                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.3),
                                builder: (context) => locationPopupCard(
                                  onAllow: () {
                                    Get.to(
                                      () => BlinxMapScreen(
                                        onLocationPicked:
                                            (latLng, locationName) {
                                              controller.locationName.value =
                                                  locationName;

                                              controller.latitude.value =
                                                  latLng.latitude;

                                              controller.longitude.value =
                                                  latLng.longitude;
                                            },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Obx(
                                      () => LargeText(
                                        text:
                                            controller
                                                .locationName
                                                .value
                                                .isNotEmpty
                                            ? controller.locationName.value
                                            : "Location",
                                      ),
                                    ),
                                  ),

                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Obx(() {
                      final isDraftLoading = controller.isDraftLoading.value;

                      final isPublishLoading =
                          controller.isPublishLoading.value;

                      final isBusy = isDraftLoading || isPublishLoading;

                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: isBusy ? null : saveAsDraft,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: isDraftLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const LargeText(
                                        text: "Save as Draft",
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
                              onTap: isBusy ? null : publishPost,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isPublishLoading
                                      ? Colors.grey.shade400
                                      : ColorConstants.primaryBlue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: isPublishLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const LargeText(
                                        text: "Publish",
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: Fonts.interSemiBold,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
