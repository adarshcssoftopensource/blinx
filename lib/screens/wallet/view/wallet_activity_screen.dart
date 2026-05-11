import 'package:blinx_mobile/screens/missions/view/missions_screen.dart';
import 'package:blinx_mobile/screens/wallet/model/wallet_list_screen_model.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';

class WalletActivityScreen extends StatelessWidget {
  final List<ActivityModel> recentActivity;

  const WalletActivityScreen({super.key, required this.recentActivity});

  static final List<ActivityModel> _staticRecentActivity = [
    ActivityModel(
      title: AppConstants.missionCompleted,
      amount: AppConstants.creditAmountDisplay,
      date: AppConstants.yesterday,
      status: AppConstants.postedStatus,
      type: ActivityType.mission,
    ),
    ActivityModel(
      title: AppConstants.missionCompleted,
      amount: AppConstants.creditAmountDisplay,
      date: AppConstants.yesterday,
      status: AppConstants.postedStatus,
      type: ActivityType.none,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activities = recentActivity.isNotEmpty
        ? recentActivity
        : _staticRecentActivity;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
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
        ),
        title: const Text(
          AppConstants.walletTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              AppConstants.recentActivityTitle,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final item = activities[index];

                  return GestureDetector(
                    onTap: () {
                      if (item.type == ActivityType.mission) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MissionsScreen(),
                          ),
                        );
                      } else if (item.type == ActivityType.none) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MissionsScreen(),
                          ),
                        );
                      }
                    },
                    child: activityCard(
                      title: item.title,
                      amount: item.amount,
                      date: item.date,
                      status: item.status,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activityCard({
    required String title,
    required String amount,
    required String date,
    required String status,
  }) {
    final bool isFailed =
        status.toLowerCase() == AppConstants.failed.toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.blue, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0E1A2B),
                  decoration: isFailed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
