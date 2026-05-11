import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/select_topic_controller.dart';
import '../model/select_topic_model.dart';

class SelectTopicScreen extends StatelessWidget {
  const SelectTopicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectTopicController controller = Get.put(SelectTopicController());

    return Scaffold(
      backgroundColor: ColorConstants.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                color: ColorConstants.white2,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),

              child: Container(
                height: 48,

                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorConstants.white2),
                ),

                child: Row(
                  children: [
                    const SizedBox(width: 14),

                    const Icon(
                      Icons.search,
                      color: ColorConstants.darkGreyColor,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: TextField(
                        onChanged: (value) =>
                            controller.searchQuery.value = value,

                        decoration: const InputDecoration(
                          hintText: AppConstants.search,
                          border: InputBorder.none,

                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorConstants.searchHintColor,
                            fontFamily: Fonts.interRegular,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),

              child: Align(
                alignment: Alignment.centerLeft,

                child: LargeText(text: AppConstants.existingTopics),
              ),
            ),

            const SizedBox(height: 10),

            // TOPICS LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = controller.searchQuery.value.isEmpty
                    ? controller.topics
                    : controller.topics
                          .where(
                            (t) => t.name.toLowerCase().contains(
                              controller.searchQuery.value.toLowerCase(),
                            ),
                          )
                          .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text(AppConstants.noTopicsFound));
                }

                return ListView.builder(
                  itemCount: filtered.length,

                  itemBuilder: (context, index) {
                    final topic = filtered[index];

                    return Obx(
                      () => _buildItem(
                        topic: topic,

                        isSelected:
                            controller.selectedTopic.value?.id == topic.id,

                        onTap: () => controller.selectTopic(topic),
                      ),
                    );
                  },
                );
              }),
            ),

            // SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 20),

              child: Obx(
                () => GestureDetector(
                  onTap: controller.selectedTopic.value == null
                      ? null
                      : () {
                          Get.back(result: controller.selectedTopic.value);
                        },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),

                    decoration: BoxDecoration(
                      color: controller.selectedTopic.value == null
                          ? Colors.grey
                          : ColorConstants.primaryBlue,

                      borderRadius: BorderRadius.circular(100),
                    ),

                    child: const LargeText(
                      text: AppConstants.submit,
                      color: ColorConstants.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required SelectTopicModel topic,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          children: [
            SizedBox(
              height: 48,

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      topic.name,

                      style: const TextStyle(
                        fontFamily: Fonts.interRegular,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),

                  if (isSelected)
                    const Icon(
                      Icons.check,
                      color: ColorConstants.primaryBlue,
                      size: 18,
                    ),
                ],
              ),
            ),

            Container(height: 0.8, color: ColorConstants.white2),
          ],
        ),
      ),
    );
  }
}
