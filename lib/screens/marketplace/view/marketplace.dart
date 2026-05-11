import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/marketplace/model/marketplace_model.dart';
import 'package:blinx_mobile/screens/marketplace_detail/view/marketplace_detail.dart';
import 'package:blinx_mobile/screens/missions/view/missions_screen.dart';
import 'package:blinx_mobile/screens/my_submission/view/my_submission.dart';
import 'package:blinx_mobile/screens/profile/view/profile_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/settings_screen/view/settings_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/topic_feed_screen/view/topic_feed_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/marketplace_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/marketplace_screen_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  // Navigates to detail screen passing only the task ID
  void _goToDetail(MarketplaceApplication item, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarketplaceDetailScreen(taskId: item.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MarketplaceScreenController());
    final PageController pageController = PageController();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ColorConstants.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstants.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          title: Text(
            AppConstants.marketplace,
            style: TextStyle(
              fontFamily: Fonts.interSemiBold,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorConstants.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.to(MySubmissionScreen()),
              child: Container(
                height: 35,
                width: 35,
                margin: const EdgeInsets.only(right: 5),
                decoration: const BoxDecoration(
                  color: ColorConstants.lighterGreyColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    CommonUi.setPngIcon("ring"),
                    width: 18,
                    height: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () => Get.to(ProfileScreen()),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstants.redColor,
                      width: 2,
                    ),
                  ),
                  child: Obx(() {
                    final image = AuthController.to.profileImage.value;
                    final ts = DateTime.now().millisecondsSinceEpoch;

                    return CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: image.isNotEmpty
                          ? NetworkImage("$image?v=$ts")
                          : null,
                      child: image.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.grey,
                            )
                          : null,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) => controller.currentPage.value = index,
                children: [_marketplacePage(controller, context)],
              ),
            ),
            _pageIndicator(controller),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 1, color: const Color(0xFFEBEBEB)),
            Obx(
              () => CustomBottomBar(
                selectedIndex: controller.selectedIndex.value,
                onTap: (index) {
                  controller.selectedIndex.value = index;
                  if (index == 2) return;
                  if (index == 0) Get.off(() => const HomeScreen());
                  if (index == 1) Get.off(() => const MissionsScreen());
                  if (index == 3) Get.off(() => const TopicFeedScreen());
                  if (index == 4) Get.off(() => const SettingsScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageIndicator(MarketplaceScreenController controller) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(1, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            width: controller.currentPage.value == index ? 12 : 8,
            height: controller.currentPage.value == index ? 12 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentPage.value == index
                  ? Colors.transparent
                  : ColorConstants.dividerColor,
            ),
          );
        }),
      ),
    );
  }

  Widget _marketplacePage(
    MarketplaceScreenController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [_searchField(controller), const SizedBox(height: 16)],
          ),
        ),
        Expanded(
          child: Obx(() {
            final mc = controller.marketplaceController;

            if (mc.isLoading.value) {
              return const MarketplaceShimmer();
            }

            final filteredApps = mc.myApplications
                .where(
                  (item) => item.title.toLowerCase().contains(
                    controller.searchQuery.value.toLowerCase(),
                  ),
                )
                .toList();

            if (filteredApps.isEmpty) {
              return const Center(
                child: Text(AppConstants.noApplicationsFound),
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !mc.isLoading.value) {
                  debugPrint("Reached bottom-Loading next page");
                  mc.loadNextPage();
                }
                return false;
              },
              child: ListView.separated(
                itemCount: filteredApps.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final item = filteredApps[index];
                  return _marketplaceItem(
                    item,
                    context,
                    showTopDivider: index != 0,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _marketplaceItem(
    MarketplaceApplication item,
    BuildContext context, {
    bool showTopDivider = true,
  }) {
    return GestureDetector(
      onTap: () => _goToDetail(item, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTopDivider)
            Container(
              width: double.infinity,
              height: 1,
              color: ColorConstants.dividerColor,
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statusChip(AppConstants.taskLabel),
                    const SizedBox(width: 8),
                    _statusChip(item.status, color: ColorConstants.blueColor),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${item.credits} CR",
                          style: const TextStyle(
                            fontFamily: Fonts.poppinsBold,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          AppConstants.internalCredits,
                          style: TextStyle(
                            fontSize: 11,
                            color: ColorConstants.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: Fonts.poppinsBold,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstants.greyColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: ColorConstants.dividerColor,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${AppConstants.growsLabel}${item.grows}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 95,
                      height: 27,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorConstants.blueColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.applicationStatus,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _searchField(MarketplaceScreenController controller) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: TextField(
          onChanged: (value) => controller.searchQuery.value = value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 10),
              child: Image.asset(
                CommonUi.setPngIcon("search"),
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            hintText: AppConstants.searchHint,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: -5, top: 7),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String title, {Color? color}) {
    return Container(
      width: 60,
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: color == null
            ? Border.all(color: ColorConstants.dividerColor, width: 0.72)
            : null,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontFamily: Fonts.poppinsMedium,
          color: color != null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
