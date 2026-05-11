import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/report_controller.dart';

class ReportScreen extends StatelessWidget {
  final String blinkId;

  const ReportScreen({super.key, required this.blinkId});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<ReportController>()) Get.delete<ReportController>();
    final controller = Get.put(ReportController()..blinkId = blinkId);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP DRAG LINE
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // TITLE
            const Center(
              child: Text(
                AppConstants.report,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              AppConstants.reportReasonTitle,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 2),
            const Text(
              AppConstants.reportReasonSubtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // CHECKBOX LIST
            ...controller.options.map(
              (option) => Obx(() {
                final isSelected = controller.selectedReasons.contains(option);
                return GestureDetector(
                  onTap: () => controller.toggleReason(option),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2A73EA)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2A73EA)
                                  : const Color(0xFFD0D5DD),
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),
            const Text(
              AppConstants.description,
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 6),

            // TEXTFIELD
            TextField(
              controller: controller.textController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // SUBMIT BUTTON
            Obx(
              () => Center(
                child: GestureDetector(
                  onTap: controller.isSubmitting.value
                      ? null
                      : () => controller.reportBlink(
                          description: controller.textController.text.trim(),
                        ),
                  child: Container(
                    width: 160,
                    height: 45,
                    decoration: BoxDecoration(
                      color: controller.isSubmitting.value
                          ? Colors.grey
                          : const Color(0xFF2A73EA),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: controller.isSubmitting.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              AppConstants.submit,
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
