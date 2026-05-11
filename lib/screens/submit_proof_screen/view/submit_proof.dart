import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/submit_controller.dart';

class SubmitProofScreen extends StatelessWidget {
  final String applicationId;
  final String missionId;

  const SubmitProofScreen({
    super.key,
    required this.applicationId,
    required this.missionId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubmitProofViewController>(
      init: SubmitProofViewController(
        applicationId: applicationId,
        missionId: missionId,
      ),
      global: false,
      builder: (viewCtrl) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Image.asset(
                CommonUi.setPngIcon("left_vector"),
                width: 8,
                height: 14,
              ),
            ),
            title: const Text(
              AppConstants.submitProofTitle,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: const Text(
                              AppConstants.submitProofMissionName,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A73EA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              AppConstants.submitProofStatusActive,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: const [
                          Icon(
                            Icons.schedule,
                            size: 15,
                            color: Color(0xFF2A73EA),
                          ),
                          SizedBox(width: 4),
                          Text(
                            AppConstants.submitProofDuration,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF51585C),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF51585C),
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.bar_chart,
                            size: 15,
                            color: Color(0xFF2A73EA),
                          ),
                          SizedBox(width: 4),
                          Text(
                            AppConstants.submitProofDifficulty,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF51585C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(thickness: 1.2, color: Color(0xFFE0E0E0)),
                      const Text(
                        AppConstants.submitProofSubtitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF51585C),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 1.2,
                  height: 1,
                  color: Color(0xFFE0E0E0),
                ),

                // ─── Upload Photos ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppConstants.uploadPhotosTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () =>
                                viewCtrl.chooseImageSource(context, index),
                            child: DottedBorder(
                              color: const Color(0xFFE0E0E0),
                              strokeWidth: 1,
                              dashPattern: const [6, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: viewCtrl.images[index] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          viewCtrl.images[index]!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.add,
                                              size: 28,
                                              color: Color(0xFFB0B0B0),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              AppConstants.addPhoto,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF9E9E9E),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF808080),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.info_outline,
                              size: 21,
                              color: Color(0xFF000000),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppConstants.uploadPhotoInfo,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF51585C),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Additional Notes ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppConstants.additionalNotes,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 5,
                        controller: viewCtrl.notesController,
                        decoration: InputDecoration(
                          hintText: AppConstants.additionalNotesHint,
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ─── Submission Requirements ───────────────────
                      const Text(
                        AppConstants.submissionRequirements,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _requirement(
                        AppConstants.minPhotosRequired,
                        showIcon: false,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        // subText: AppConstants.photoAddedText,
                        subText: AppConstants.minPhotosAdded,
                      ),
                      const SizedBox(height: 6),
                      _requirement(
                        AppConstants.minCharsRequired,
                        showIcon: false,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        subText: AppConstants.minCharsRequired,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1.2,
                  color: const Color(0xFFE0E0E0),
                ),
                const SizedBox(height: 16),

                // ─── What Happens Next ─────────────────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    AppConstants.whatHappensNext,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.only(left: 22, right: 10),
                  child: Column(
                    children: [
                      _stepItem(
                        step: '1',
                        title: AppConstants.stepSubmitProof,
                        // subtitle: AppConstants.stepSubmitProofSub,
                        subtitle: AppConstants.stepSubmitSubtitle,
                      ),
                      _stepItem(
                        step: '2',
                        title: AppConstants.stepUnderReview,
                        // subtitle: AppConstants.stepUnderReviewSub,
                        subtitle: AppConstants.stepUnderReviewSubtitle,
                      ),
                      _stepItem(
                        step: '3',
                        title: AppConstants.stepRewardsEarned,

                        // subtitle: AppConstants.stepRewardsEarnedSub,
                        subtitle: AppConstants.stepRewardsSubtitle,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Submit Button ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewCtrl.canSubmit
                              ? const Color(0xFF2A73EA)
                              : const Color(0xFFEFEFEF),
                          foregroundColor: viewCtrl.canSubmit
                              ? Colors.white
                              : const Color(0xFFB9B9B9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed:
                            viewCtrl.canSubmit &&
                                !viewCtrl.submitController.isSubmitting.value
                            ? viewCtrl.onSubmit
                            : null,
                        child: viewCtrl.submitController.isSubmitting.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                AppConstants.submitProofButton,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Cancel ────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      // AppConstants.cancel,
                      AppConstants.cancelLabel,
                      style: TextStyle(fontSize: 14, color: Color(0xFF51585C)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _requirement(
    String text, {
    bool showIcon = true,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    String? subText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showIcon)
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Color(0xFF2A73EA),
                ),
              if (showIcon) const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
              ),
            ],
          ),
          if (subText != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF51585C),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _stepItem({
    required String step,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFAEB6BA),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    step,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAEB6BA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 1.5,
                  height: 40,
                  color: const Color(0xFFAEB6BA),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF51585C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
