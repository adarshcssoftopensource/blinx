import 'dart:io';

import 'package:blinx_mobile/screens/submit_proof_screen/controller/submit_proof_controller.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// ─── ViewController ────────────────
class SubmitProofViewController extends GetxController {
  final String applicationId;
  final String missionId;

  SubmitProofViewController({
    required this.applicationId,
    required this.missionId,
  });

  final ImagePicker picker = ImagePicker();
  final List<File?> images = List.generate(4, (_) => null);
  final TextEditingController notesController = TextEditingController();
  final SubmitProofController submitController = Get.put(
    SubmitProofController(),
  );

  bool get canSubmit => images.any((img) => img != null);

  @override
  void onInit() {
    super.onInit();
    debugPrint("SubmitProofScreen — applicationId: $applicationId");
    debugPrint("SubmitProofScreen — missionId: $missionId");
  }

  @override
  void onClose() {
    notesController.dispose();
    Get.delete<SubmitProofController>();
    super.onClose();
  }

  Future<void> chooseImageSource(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text(AppConstants.cameraOption),
              onTap: () {
                Navigator.pop(context);
                pickImage(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text(AppConstants.galleryOption),
              onTap: () {
                Navigator.pop(context);
                pickImage(index, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(int index, ImageSource source) async {
    try {
      final XFile? picked = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (picked != null) {
        final file = File(picked.path);
        if (await file.exists()) {
          images[index] = file;
          update();
          debugPrint("Image picked at slot $index: ${picked.path}");
        } else {
          debugPrint("File does not exist: ${picked.path}");
        }
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  void onSubmit() {
    final photos = images.whereType<File>().toList();

    debugPrint("======= Submit Proof API Call =======");
    debugPrint("missionId: $missionId");
    debugPrint("applicationId: $applicationId");
    debugPrint("Photos count: ${photos.length}");
    debugPrint("Notes: ${notesController.text}");
    for (int i = 0; i < photos.length; i++) {
      debugPrint("Photo[$i]: ${photos[i].path}");
    }
    debugPrint("============");

    submitController.submitProof(
      missionId: missionId,
      notes: notesController.text,
      photos: photos,
    );
  }
}
