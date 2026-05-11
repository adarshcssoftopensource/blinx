import 'package:blinx_mobile/screens/profile/plans/plan_shimmer.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/widgets/medium_text.dart';
import 'package:blinx_mobile/widgets/new_plan_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';
import 'controller/plan_screen_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class NewPlanScreen extends StatelessWidget {
  const NewPlanScreen({super.key});

  Widget _label(String text) =>
      SmallText(text: text, fontSize: 13, color: ColorConstants.black);

  BoxDecoration get _fieldDecoration => BoxDecoration(
    color: const Color(0xFFF5F5F0),
    borderRadius: BorderRadius.circular(8),
  );

  Widget _statusDot(String status) {
    final color = switch (status) {
      'UPCOMING' => const Color(0xFF4A90E2),
      'SHARED' => const Color(0xFF7ED321),
      'COMPLETED' => const Color(0xFF9B9B9B),
      _ => Colors.transparent,
    };
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewPlanScreenController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => controller.showPlaceDropdown.value = false,
          behavior: HitTestBehavior.translucent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/icons/left_vector.png',
                      width: 15,
                      height: 15,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: SmallText(
                        text: AppConstants.createPlan,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Fonts.interMedium,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
              const SizedBox(height: 28),
              Expanded(
                child: Obx(
                  () => controller.isInitialLoading.value
                      ? const NewPlanShimmer()
                      : SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.045,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label(AppConstants.title),
                              const SizedBox(height: 8),
                              Container(
                                decoration: _fieldDecoration,
                                child: TextField(
                                  controller: controller.titleController,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: AppConstants.planTitle,

                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black38,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _label(AppConstants.summary),
                              const SizedBox(height: 8),
                              Container(
                                decoration: _fieldDecoration,
                                child: TextField(
                                  controller: controller.descriptionController,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: AppConstants.shortSummary,

                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black38,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(14),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _label(AppConstants.dates),
                              const SizedBox(height: 8),
                              // ✅ startDate/endDate Obx se reactive
                              Obx(
                                () => GestureDetector(
                                  onTap: () =>
                                      controller.pickDateRange(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: _fieldDecoration,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SmallText(
                                            text: controller.dateRangeText,
                                            fontSize: 14,
                                            color:
                                                controller.startDate.value ==
                                                    null
                                                ? ColorConstants.textSecondary
                                                : ColorConstants.black,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 16,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _label(AppConstants.plans),
                              const SizedBox(height: 8),
                              Obx(() {
                                final isLoading = controller
                                    .plansController
                                    .isLoadingSavedPlaces
                                    .value;
                                final places =
                                    controller.plansController.savedPlaces;

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (!isLoading && places.isNotEmpty) {
                                          controller.showPlaceDropdown.value =
                                              !controller
                                                  .showPlaceDropdown
                                                  .value;
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        decoration: _fieldDecoration,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: Colors.black38,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: isLoading
                                                  ? const SmallText(
                                                      text: AppConstants
                                                          .loadingPlaces,

                                                      fontSize: 14,
                                                      color: ColorConstants
                                                          .textSecondary,
                                                    )
                                                  : places.isEmpty
                                                  ? const SmallText(
                                                      text: AppConstants
                                                          .noSavedPlaces,
                                                      fontSize: 14,
                                                      color: ColorConstants
                                                          .textSecondary,
                                                    )
                                                  : SmallText(
                                                      text:
                                                          controller
                                                              .selectedPlaces
                                                              .isEmpty
                                                          ? AppConstants
                                                                .selectPlaces
                                                          : "${controller.selectedPlaces.length} ${AppConstants.place}${controller.selectedPlaces.length > 1 ? 's' : ''} selected",
                                                      fontSize: 14,
                                                      color:
                                                          controller
                                                              .selectedPlaces
                                                              .isEmpty
                                                          ? ColorConstants
                                                                .textSecondary
                                                          : ColorConstants
                                                                .black,
                                                    ),
                                            ),
                                            if (isLoading)
                                              const SizedBox(
                                                width: 14,
                                                height: 14,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.black45,
                                                    ),
                                              )
                                            else
                                              Icon(
                                                controller
                                                        .showPlaceDropdown
                                                        .value
                                                    ? Icons
                                                          .keyboard_arrow_up_rounded
                                                    : Icons
                                                          .keyboard_arrow_down_rounded,
                                                color: Colors.black45,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (controller.selectedPlaces.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: controller.selectedPlaces.map((
                                            place,
                                          ) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE8F0FE),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (place
                                                      .thumbnailUrl
                                                      .isNotEmpty)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      child: Image.network(
                                                        place.thumbnailUrl,
                                                        width: 18,
                                                        height: 18,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (
                                                              _,
                                                              __,
                                                              ___,
                                                            ) => const Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size: 14,
                                                              color: Colors
                                                                  .black45,
                                                            ),
                                                      ),
                                                    )
                                                  else
                                                    const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 14,
                                                      color: Colors.black45,
                                                    ),
                                                  const SizedBox(width: 5),
                                                  SmallText(
                                                    text: place.name,
                                                    fontSize: 12,
                                                    color: ColorConstants.black,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  GestureDetector(
                                                    onTap: () => controller
                                                        .selectedPlaces
                                                        .remove(place),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 13,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    if (controller.showPlaceDropdown.value &&
                                        places.isNotEmpty)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        constraints: const BoxConstraints(
                                          maxHeight: 240,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.06,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          itemCount: places.length,
                                          separatorBuilder: (_, __) =>
                                              const Divider(
                                                height: 1,
                                                color: Colors.black12,
                                              ),
                                          itemBuilder: (_, i) {
                                            final place = places[i];
                                            final isSelected = controller
                                                .selectedPlaces
                                                .any((p) => p.id == place.id);

                                            return InkWell(
                                              onTap: () {
                                                if (isSelected) {
                                                  controller.selectedPlaces
                                                      .removeWhere(
                                                        (p) => p.id == place.id,
                                                      );
                                                } else {
                                                  controller.selectedPlaces.add(
                                                    place,
                                                  );
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 10,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? ColorConstants
                                                                  .blueColor
                                                            : Colors
                                                                  .transparent,
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? ColorConstants
                                                                    .blueColor
                                                              : Colors.black26,
                                                          width: 1.5,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: isSelected
                                                          ? const Icon(
                                                              Icons.check,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          : null,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      child:
                                                          place
                                                              .thumbnailUrl
                                                              .isNotEmpty
                                                          ? Image.network(
                                                              place
                                                                  .thumbnailUrl,
                                                              width: 36,
                                                              height: 36,
                                                              fit: BoxFit.cover,
                                                              loadingBuilder:
                                                                  (
                                                                    context,
                                                                    child,
                                                                    loadingProgress,
                                                                  ) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return const ShimmerBox(
                                                                      width: 36,
                                                                      height:
                                                                          36,
                                                                    );
                                                                  },
                                                              errorBuilder:
                                                                  (
                                                                    _,
                                                                    __,
                                                                    ___,
                                                                  ) => const Icon(
                                                                    Icons
                                                                        .location_on_outlined,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size: 20,
                                                              color: Colors
                                                                  .black45,
                                                            ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SmallText(
                                                            text: place.name,
                                                            fontSize: 13,
                                                            color:
                                                                ColorConstants
                                                                    .black,
                                                          ),
                                                          SmallText(
                                                            text: place
                                                                .locationName,
                                                            fontSize: 11,
                                                            color: ColorConstants
                                                                .textSecondary,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    if (controller.showPlaceDropdown.value)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () =>
                                              controller
                                                      .showPlaceDropdown
                                                      .value =
                                                  false,
                                          child: SmallText(
                                            text: AppConstants.done,
                                            fontSize: 13,
                                            color: ColorConstants.blueColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 20),
                              _label(AppConstants.status),
                              const SizedBox(height: 8),
                              // ✅ selectedStatus Obx se reactive
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 4,
                                  ),
                                  decoration: _fieldDecoration,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller.selectedStatus.value,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black45,
                                      ),
                                      items: controller.statusOptions.map((
                                        status,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: status,
                                          child: Row(
                                            children: [
                                              _statusDot(status),
                                              const SizedBox(width: 8),
                                              SmallText(
                                                text: status,
                                                fontSize: 14,
                                                color: ColorConstants.black,
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) =>
                                          controller.selectedStatus.value =
                                              val ?? AppConstants.upcoming,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Obx(
                                () => GestureDetector(
                                  onTap:
                                      controller.plansController.isLoading.value
                                      ? null
                                      : () => controller.onCreatePlan(context),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorConstants.blueColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child:
                                          controller
                                              .plansController
                                              .isLoading
                                              .value
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : MediumText(
                                              text: AppConstants.save,
                                              fontSize: 14,
                                              fontFamily: Fonts.interSemiBold,
                                              color: ColorConstants.white,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
