import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../my_submission/widget/full_screen_photo_widget.dart';
import '../controller/view_controller.dart';

// ─── ViewSubmit Screen ────────────────────────────────────────────────────────

class ViewSubmit extends StatelessWidget {
  final String missionId;

  const ViewSubmit({super.key, required this.missionId});

  @override
  Widget build(BuildContext context) {
    final screenController = Get.put(
      ViewSubmitScreenController(missionId: missionId),
    );

    final controller = screenController.controller;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        surfaceTintColor: Colors.white,

        backgroundColor: Colors.white,

        elevation: 0,

        leading: GestureDetector(
          onTap: () => Navigator.pop(context),

          child: Center(
            child: SizedBox(
              width: 15,

              height: 15,

              child: Image.asset(
                CommonUi.setPngIcon("left_vector"),

                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        title: const Text(
          AppConstants.viewSubmitProofTitle,

          style: TextStyle(
            fontSize: 14,

            fontWeight: FontWeight.w500,

            color: Colors.black,
          ),
        ),

        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2A73EA),

              strokeWidth: 2,
            ),
          );
        }

        final data = controller.submitData.value;

        if (data == null) {
          return const Center(
            child: Text(
              AppConstants.failedToLoadSubmission,

              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 14, color: Color(0xFF51585C)),
            ),
          );
        }

        final statusStyle = screenController.statusStyle(data.status);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Text(
                      data.missionTitle,

                      style: const TextStyle(
                        fontSize: 14,

                        fontWeight: FontWeight.w700,

                        color: Colors.black,
                      ),
                    ),
                  ),

                  Container(
                    height: 27,

                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    decoration: BoxDecoration(
                      color: statusStyle['bg'],

                      borderRadius: BorderRadius.circular(100),
                    ),

                    alignment: Alignment.center,

                    child: Text(
                      statusStyle['text'],

                      style: const TextStyle(
                        fontSize: 13,

                        fontWeight: FontWeight.w500,

                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  const Icon(
                    Icons.schedule,

                    size: 16,

                    color: Color(0xFF2A73EA),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    data.duration,

                    style: const TextStyle(
                      fontSize: 14,

                      color: Color(0xFF51585C),
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Icon(
                    Icons.bar_chart,

                    size: 16,

                    color: Color(0xFF2A73EA),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    data.difficulty,

                    style: const TextStyle(
                      fontSize: 14,

                      color: Color(0xFF51585C),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                AppConstants.proofPhotos,

                style: TextStyle(
                  fontSize: 14,

                  fontWeight: FontWeight.w600,

                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 88,

                child: data.photos.isEmpty
                    ? const Center(
                        child: Text(
                          AppConstants.noPhotosSubmitted,

                          style: TextStyle(
                            fontSize: 13,

                            color: Color(0xFF51585C),
                          ),
                        ),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,

                        padding: const EdgeInsets.only(right: 8),

                        itemCount: data.photos.length,

                        separatorBuilder: (_, __) => const SizedBox(width: 12),

                        itemBuilder: (context, index) {
                          final screenWidth = MediaQuery.of(context).size.width;

                          final itemWidth = (screenWidth - 32 - 24) / 3.2;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => FullScreenPhotos(
                                    photos: data.photos,

                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },

                            child: Container(
                              width: itemWidth,

                              padding: const EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                color: const Color(0xFFE7F4F8),

                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),

                                child: Image.network(
                                  data.photos[index],

                                  height: 40,

                                  fit: BoxFit.cover,

                                  errorBuilder: (_, __, ___) => Image.asset(
                                    CommonUi.setPngIcon("frame"),

                                    height: 40,

                                    fit: BoxFit.contain,
                                  ),

                                  loadingBuilder: (_, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return const Center(
                                      child: SizedBox(
                                        width: 16,

                                        height: 16,

                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.5,

                                          color: Color(0xFF2A73EA),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),

              const Text(
                AppConstants.additionalNotesLabel,

                style: TextStyle(
                  fontSize: 14,

                  fontWeight: FontWeight.w600,

                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                data.notes,

                style: const TextStyle(
                  fontSize: 13,

                  height: 1.6,

                  color: Color(0xFF51585C),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}
