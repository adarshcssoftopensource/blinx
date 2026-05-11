import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/full_screen_photo_controller.dart';

// ─── FullScreenPhotos Screen ──────────────────────────────────────────────────

class FullScreenPhotos extends StatelessWidget {
  final List<String> photos;

  final int initialIndex;

  const FullScreenPhotos({required this.photos, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      FullScreenPhotosController(initialIndex: initialIndex),
    );

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        elevation: 0,

        leading: GestureDetector(
          onTap: () => Navigator.pop(context),

          child: const Center(
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          ),
        ),
      ),

      body: PageView.builder(
        controller: controller.pageController,

        itemCount: photos.length,

        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                photos[index],

                fit: BoxFit.contain,

                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,

                  color: Colors.white,

                  size: 48,
                ),

                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,

                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
