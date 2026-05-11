import 'package:blinx_mobile/screens/wallet/model/wallet_list_screen_model.dart';
import 'package:blinx_mobile/screens/wallet/view/wallet_activity_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/wallet_screen_controller.dart';

class WalletOverviewScreen extends StatelessWidget {
  WalletOverviewScreen({super.key});

  final WalletScreenController controller = Get.put(WalletScreenController());

  @override
  Widget build(BuildContext context) {
    controller.loadWalletLedger();

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
          AppConstants.walletTitle,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A8CFF), Color(0xFF166BFF)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppConstants.availableCredits,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        Image.asset(
                          CommonUi.setPngIcon("wallet"),
                          height: 22,
                          width: 22,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Obx(() {
                      final credits = controller.walletCredits.value;

                      String displayValue = '–';

                      if (credits != null) {
                        if (credits % 1 == 0) {
                          displayValue = credits.toInt().toString();
                        } else {
                          displayValue = credits.toString();
                        }
                      }

                      return Text(
                        displayValue,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Container(height: 1, color: const Color(0xFFE0E5EE)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            controller.microGrantsBalance.value != null
                                ? "${AppConstants.microGrantsBalance}\n\$${controller.microGrantsBalance.value!.toStringAsFixed(2)}"
                                : "${AppConstants.creditsBalanceNonCash}\n–",
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                            color: Colors.white.withOpacity(0.12),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.verified,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                AppConstants.walletApproved,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      AppConstants.walletDisclaimer,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                AppConstants.reputationScore,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.reputationScores.isEmpty) {
                  return const Text(
                    AppConstants.reputationDataPending,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  );
                }

                List<Widget> rows = [];

                for (
                  int i = 0;
                  i < controller.reputationScores.length;
                  i += 2
                ) {
                  rows.add(
                    Row(
                      children: [
                        Expanded(
                          child: reputationItem(
                            controller.reputationScores[i].label,
                            controller.reputationScores[i].score,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (i + 1 < controller.reputationScores.length)
                          Expanded(
                            child: reputationItem(
                              controller.reputationScores[i + 1].label,
                              controller.reputationScores[i + 1].score,
                            ),
                          ),
                        if (i + 1 >= controller.reputationScores.length)
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  );

                  rows.add(const SizedBox(height: 10));
                }

                return Column(children: rows);
              }),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppConstants.recentActivity,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WalletActivityScreen(
                            recentActivity: controller.recentActivity
                                .map(
                                  (e) => ActivityModel(
                                    title: e['title']?.toString() ?? '',
                                    amount: e['amount']?.toString() ?? '',
                                    date: e['date']?.toString() ?? '',
                                    status: e['status']?.toString() ?? '',
                                    type: e['type']?.toString() == 'mission'
                                        ? ActivityType.mission
                                        : ActivityType.none,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      AppConstants.seeAll,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0E1A2B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              activityTile(
                title: AppConstants.missionCompleted,
                date: AppConstants.yesterday,
                amount: AppConstants.creditAmountDisplay,
                color: Colors.blue,
                status: AppConstants.postedStatus,
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget walletOption(BuildContext context, String assetPath, String title) {
    double boxWidth = (MediaQuery.of(context).size.width - 16 * 2 - 16) / 3;

    return Container(
      width: boxWidth,
      height: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, height: 36, width: 36),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget reputationItem(String title, int? value) {
    final displayValue = value ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, -10),
            child: Text(
              value != null ? displayValue.toString() : "–",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value != null ? displayValue / 100 : 0,
            minHeight: 4,
            color: Colors.blue,
            backgroundColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  Widget activityTile({
    required String title,
    required String date,
    required String amount,
    required Color color,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 26, color: color),
          const SizedBox(width: 14),
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
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E1A2B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
