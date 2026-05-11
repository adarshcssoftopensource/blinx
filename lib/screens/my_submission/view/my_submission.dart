import 'package:blinx_mobile/screens/my_submission/controller/my_submission_controller.dart';
import 'package:blinx_mobile/screens/my_submission/widget/photo_box_widget.dart';
import 'package:blinx_mobile/screens/wallet/view/wallet_overview_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/my_submission_shimmer.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/video_player_screen.dart';

class MySubmissionScreen extends StatelessWidget {
  MySubmissionScreen({super.key});

  final MySubmissionController mySubmissionController = Get.put(
    MySubmissionController(),
  );

  // Capitalizes only first letter
  String capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  void openWalletScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => WalletOverviewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    mySubmissionController.getMySubmissionApi();

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
          AppConstants.missionProofSubmission,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (mySubmissionController.isLoading.value) {
          return const MySubmissionShimmer();
        }

        final submissions =
            mySubmissionController.mySubmissionData.value?.data.submissions;

        if (submissions == null || submissions.isEmpty) {
          return const Center(child: Text(AppConstants.noDataAvailable));
        }

        final mySubmission =
            submissions.firstWhereOrNull(
              (s) => s.status.trim().toLowerCase() == AppConstants.rejected,
            ) ??
            submissions.firstWhereOrNull(
              (s) => s.status.trim().toLowerCase() == AppConstants.pending,
            ) ??
            submissions.last;

        final status = mySubmission.status.trim().toLowerCase();

        final bool isApproved = status == AppConstants.approved;
        final bool isRejected = status == AppConstants.rejected;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12, width: 0.9),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 22),
                          Text(
                            AppConstants.cleanupTaskTitle,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            AppConstants.creditsEcoWarrior,
                            style: TextStyle(
                              height: 1.4,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isApproved
                              ? Colors.green
                              : isRejected
                              ? Colors.red
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: isApproved
                              ? () => openWalletScreen(context)
                              : null,
                          child: Text(
                            capitalizeFirst(mySubmission.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                AppConstants.definitionOfDone,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              const Text(
                AppConstants.dodPlaceholder,
                style: TextStyle(
                  height: 1.45,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                AppConstants.proofOfWork,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              submissionPhotosBox(context, mySubmission.photos),

              const SizedBox(height: 8),

              mySubmission.videoThumbnail?.isNotEmpty == true
                  ? GestureDetector(
                      onTap: () {
                        final controller = VideoPlayerController.networkUrl(
                          Uri.parse(mySubmission.videoUrl!),
                        );

                        Get.to(
                          () => FullScreenVideoPlayer(controller: controller),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              mySubmission.videoThumbnail!,
                              fit: BoxFit.cover,
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;

                                    return ShimmerLoader(
                                      height: 200,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(10),
                                    );
                                  },
                              errorBuilder: (_, __, ___) => Container(
                                height: 200,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(height: 120),

              Center(
                child: SizedBox(
                  width: 176,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isApproved
                        ? () => openWalletScreen(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApproved
                          ? const Color(0xFF2A73EA)
                          : Colors.grey,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      AppConstants.submitWork,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
