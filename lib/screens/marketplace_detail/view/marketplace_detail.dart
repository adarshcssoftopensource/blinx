import 'package:blinx_mobile/screens/task_submission/view/task_submission_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application_form/view/application_form.dart';
import '../../my_submission/view/my_submission.dart';
import '../controller/marketplace_detail_controller.dart';
import '../model/marketplace_detail_model.dart';

class MarketplaceDetailScreen extends StatelessWidget {
  final String taskId;

  const MarketplaceDetailScreen({super.key, required this.taskId});

  void _goToApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ApplicationFormScreen(taskId: taskId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MarketplaceDetailController(),
      tag: 'user_detail',
    );
    controller.fetchDetail(taskId);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 15,
            width: 15,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppConstants.marketplaceDetail,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final MarketplaceDetail? data = controller.detail.value;

        if (data == null) {
          return const Center(child: Text(AppConstants.noDataFound));
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: _detailContent(context, data),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Center(
                child: IntrinsicWidth(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: data.applicationStatus == AppConstants.pending
                          ? null
                          : () {
                              if (data.workSubmissionStatus ==
                                      AppConstants.pending ||
                                  data.workSubmissionStatus ==
                                      AppConstants.approved) {
                                Get.to(MySubmissionScreen());
                              } else if (data.applicationStatus != '') {
                                Get.to(
                                  TaskSubmissionScreen(
                                    applicationId: data.applicationId,
                                  ),
                                );
                              } else {
                                _goToApplication(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A73EA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        data.applicationStatus == AppConstants.pending
                            ? AppConstants.applicationUnderReview
                            : data.workSubmissionStatus ==
                                      AppConstants.pending ||
                                  data.workSubmissionStatus ==
                                      AppConstants.approved
                            ? AppConstants.checkYourSubmission
                            : AppConstants.applyForTask,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _detailContent(BuildContext context, MarketplaceDetail data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 0),
        Row(
          children: [
            _chip(
              data.type,
              selected: false,
              width: 75,
              height: 29,
              radius: 50,
              borderWidth: 0.72,
            ),
            const SizedBox(width: 10),
            _chip(
              AppConstants.oneHour,
              selected: true,
              width: 74,
              height: 29,
              radius: 50,
              borderWidth: 0.72,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          data.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          data.description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _infoCard(
                title: AppConstants.reward,
                subtitle: "${data.rewardCredit} CR",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _infoCard(
                title: AppConstants.reputation,
                subtitle: AppConstants.reputation,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          AppConstants.definitionOfDone,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        _bullet(data.definitionOfDone),
        const SizedBox(height: 20),
        const Text(
          AppConstants.requiredProof,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        _bullet(data.requiredProof),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _chip(
    String text, {
    required bool selected,
    double width = double.infinity,
    double height = 32,
    double radius = 20,
    double borderWidth = 1,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3478F6) : Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: selected ? const Color(0xFF3478F6) : Colors.grey.shade300,
          width: borderWidth,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(CommonUi.setPngIcon("badges"), width: 31, height: 31),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 0),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 16, height: 1.4)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
