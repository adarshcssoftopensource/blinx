import 'package:blinx_mobile/steward_screen/marketplace_detail/controller/marketplace_detail_controller.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/snackbar_helper.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/marketplace_detail_shimmer.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../screens/my_submission/widget/full_screen_photo_widget.dart';
import '../../../widgets/video_player_screen.dart';

class MarketPlaceDetail extends StatelessWidget {
  final String applicationID;

  const MarketPlaceDetail({super.key, required this.applicationID});

  @override
  Widget build(BuildContext context) {
    final StewardMarketplaceDetailController marketplaceDetailController =
        Get.put(StewardMarketplaceDetailController());

    final TextEditingController rejectController = TextEditingController();

    marketplaceDetailController.getMarketPlaceDetailApi(
      applicationId: applicationID,
    );

    const Color bg = Colors.white;
    const Color cardBorder = Color(0xFFE9EDF2);
    const Color smallText = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 14,
            width: 14,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          AppConstants.marketplaceDetail,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Obx(() {
        if (marketplaceDetailController.isLoading.value) {
          return const MarketplaceDetailShimmer();
        } else if (marketplaceDetailController.marketPlaceData.value?.data ==
            null) {
          return const Center(child: Text(AppConstants.noDataFound));
        } else {
          final applicationData =
              marketplaceDetailController.marketPlaceData.value?.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicationData?.detail?.task?.title ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            applicationData?.detail?.task?.publishedAt ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: smallText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 8),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(
                              applicationData
                                      ?.detail
                                      ?.applicant
                                      ?.profileImage ??
                                  'https://eu.view-avatars.com/api/?name=${applicationData?.detail?.applicant?.name}&size=250',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AppConstants.memberPrefix}${applicationData?.detail?.applicant?.name ?? ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                AppConstants.reputationTierContributor,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: smallText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  AppConstants.proofOfWork,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                (marketplaceDetailController
                            .marketPlaceData
                            .value
                            ?.data
                            ?.detail
                            ?.photos
                            .isNotEmpty ??
                        false)
                    ? _submissionPhotosBox(
                        context,
                        marketplaceDetailController
                                .marketPlaceData
                                .value
                                ?.data
                                ?.detail
                                ?.photos ??
                            [],
                      )
                    : const SizedBox(),
                const SizedBox(height: 8),
                marketplaceDetailController
                            .marketPlaceData
                            .value
                            ?.data
                            ?.detail
                            ?.videoThumbnail
                            ?.isNotEmpty ==
                        true
                    ? GestureDetector(
                        onTap: () {
                          final videoController =
                              VideoPlayerController.networkUrl(
                                Uri.parse(
                                  marketplaceDetailController
                                          .marketPlaceData
                                          .value
                                          ?.data!
                                          .detail
                                          ?.videoUrl ??
                                      '',
                                ),
                              );
                          Get.to(
                            () => FullScreenVideoPlayer(
                              controller: videoController,
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                marketplaceDetailController
                                        .marketPlaceData
                                        .value
                                        ?.data
                                        ?.detail
                                        ?.videoThumbnail ??
                                    '',
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
                const SizedBox(height: 18),
                const Text(
                  AppConstants.definitionOfDone,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  applicationData?.detail?.task?.definitionOfDone ?? '',
                  style: const TextStyle(fontSize: 14, color: smallText),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppConstants.configuredReward,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppConstants.creditAmount,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: smallText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${applicationData?.detail?.task?.rewardCredit ?? ''}${AppConstants.creditsLabel}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (applicationData?.detail?.canApprove == true ||
                    applicationData?.detail?.canReject == true) ...[
                  const Text(
                    AppConstants.ifRejecting,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 118,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: cardBorder),
                    ),
                    child: TextField(
                      maxLines: null,
                      controller: rejectController,
                      decoration: const InputDecoration.collapsed(
                        hintText: AppConstants.rejectReasonHint,
                        hintStyle: TextStyle(color: smallText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 138,
                            child: ElevatedButton(
                              onPressed: () {
                                marketplaceDetailController
                                    .acceptApplicationApi(
                                      applicationId:
                                          applicationData?.detail?.id ?? '',
                                      postData: {},
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A73EA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                AppConstants.approve,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 50,
                            width: 119,
                            child: ElevatedButton(
                              onPressed: () {
                                final reason = rejectController.text.trim();
                                if (reason.isEmpty) {
                                  AppSnackbar.show(
                                    title: AppConstants.reasonRequired,
                                    message: AppConstants.enterRejectReason,
                                    isSuccess: false,
                                  );
                                  return;
                                }
                                if (reason.length <= 10) {
                                  AppSnackbar.show(
                                    title: AppConstants.invalidReason,
                                    message: AppConstants.reasonMinLength,
                                    isSuccess: false,
                                  );
                                  return;
                                }
                                marketplaceDetailController
                                    .rejectApplicationApi(
                                      applicationId:
                                          applicationData?.detail?.id ?? '',
                                      postData: {"reason": reason},
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE94E45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                AppConstants.reject,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _submissionPhotosBox(BuildContext context, List<String> photos) {
    final displayPhotos = photos.take(5).toList();
    if (displayPhotos.isEmpty) return const SizedBox.shrink();
    if (displayPhotos.length == 1) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  FullScreenPhotos(photos: displayPhotos, initialIndex: 0),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            displayPhotos.first,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 200,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridWidth = constraints.maxWidth;
        final halfWidth = (gridWidth - 8) / 2;
        return Wrap(
          spacing: 8,
          runSpacing: 11,
          children: List.generate(displayPhotos.length, (index) {
            bool isLastOdd =
                displayPhotos.length.isOdd && index == displayPhotos.length - 1;
            double width = isLastOdd ? gridWidth : halfWidth;
            double height = 130;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenPhotos(
                      photos: displayPhotos,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  displayPhotos[index],
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return ShimmerLoader(
                      height: height,
                      width: width,
                      borderRadius: BorderRadius.circular(12),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    width: width,
                    height: height,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
