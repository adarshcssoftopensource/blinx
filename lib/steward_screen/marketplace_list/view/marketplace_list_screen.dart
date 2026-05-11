import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/my_submission/view/my_submission.dart';
import 'package:blinx_mobile/screens/profile/view/profile_screen.dart';
import 'package:blinx_mobile/screens/task_submission/view/task_submission_screen.dart';
import 'package:blinx_mobile/steward_screen/marketplace_detail/view/marketplace_detail.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/marketplace_list_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/marketplace_list_screen_controller.dart';

class MarketplaceListScreen extends StatelessWidget {
  const MarketplaceListScreen({super.key});

  void _goToDetail(String applicationId) {
    Get.to(() => MarketPlaceDetail(applicationID: applicationId));
  }

  Widget _statusTag(String status) {
    final s = status.trim().toLowerCase();
    Color bg;
    String text;

    if (s == AppConstants.approved) {
      bg = Colors.green;
      text = AppConstants.approved.capitalizeFirst!;
    } else if (s == AppConstants.rejected) {
      bg = Colors.red;
      text = AppConstants.rejected.capitalizeFirst!;
    } else {
      bg = Colors.orange;
      text = AppConstants.pending.capitalizeFirst!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MarketplaceListScreenController());

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppConstants.marketplace,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.to(() => MySubmissionScreen()),
              child: Container(
                height: 35,
                width: 35,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFEDEFF2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none, size: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Get.to(() => ProfileScreen()),
                child: FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    StoreServices.getProfileImage(),
                    StoreServices.getUserName(),
                  ]),
                  builder: (context, snapshot) {
                    String initials = '';
                    String? imageUrl;

                    if (snapshot.hasData) {
                      imageUrl = snapshot.data![0] as String?;
                      final name = snapshot.data![1] as String? ?? '';
                      final trimmed = name.trim();
                      if (trimmed.isNotEmpty) {
                        final parts = trimmed.split(RegExp(r'\s+'));
                        initials =
                            (parts.length >= 2
                                    ? (parts[0][0] + parts[1][0])
                                    : trimmed.substring(
                                        0,
                                        trimmed.length >= 2 ? 2 : 1,
                                      ))
                                .toUpperCase();
                      }
                    }

                    return CircleAvatar(
                      radius: 19,
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.grey.shade400,
                        backgroundImage:
                            (imageUrl != null && imageUrl.isNotEmpty)
                            ? NetworkImage(imageUrl)
                            : null,
                        child: (imageUrl == null || imageUrl.isEmpty)
                            ? Text(
                                initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _searchBar(controller),
              const SizedBox(height: 25),
              Expanded(child: Obx(() => _buildTaskList(controller))),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => controller.isSteward.value
              ? const SizedBox.shrink()
              : Obx(
                  () => CustomBottomBar(
                    selectedIndex: controller.selectedIndex.value,
                    onTap: (index) {
                      controller.selectedIndex.value = index;
                      if (index == 0) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MarketplaceListScreen(),
                          ),
                        );
                      } else if (index == 2) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const TaskSubmissionScreen(applicationId: ''),
                          ),
                        );
                      }
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _searchBar(MarketplaceListScreenController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.shade400, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: (val) => controller.searchQuery.value = val,
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
              color: Colors.black45,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(left: -5, top: 7),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(MarketplaceListScreenController controller) {
    final mc = controller.marketplaceListController;

    if (mc.isLoading.value) {
      return const MarketplaceListShimmer(
        itemCount: 5,
        cardType: MarketplaceCardType.text,
      );
    }

    final items = mc.marketData.value?.data?.dashboardItems ?? [];

    final filteredItems = items
        .where(
          (item) => (item.taskTitle ?? '').toLowerCase().contains(
            controller.searchQuery.value.toLowerCase(),
          ),
        )
        .toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 50, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              AppConstants.noTasksAvailable,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(AppConstants.refreshPrompt, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => mc.getMarketPlaceApi(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3478F6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                AppConstants.retry,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: filteredItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return GestureDetector(
          onTap: () => _goToDetail(item.id ?? ''),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _statusTag(item.status ?? ''),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${item.rewardCredit ?? 0} CR",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              AppConstants.internalCredits,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.taskTitle ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.taskDescription ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (item.type != null && item.type!.isNotEmpty)
                              ? "${item.type![0].toUpperCase()}${item.type!.substring(1)}"
                              : '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3478F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            AppConstants.viewDetails,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const Divider(thickness: 0.4, color: Colors.grey, height: 0),
            ],
          ),
        );
      },
    );
  }
}
