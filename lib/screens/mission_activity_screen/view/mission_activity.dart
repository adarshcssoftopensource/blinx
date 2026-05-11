import 'package:blinx_mobile/screens/view_submit_screen/view/view_submit.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mission_activity_screen_controller.dart';
import '../model/mission_activity_model.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class MissionActivity extends StatelessWidget {
  final String missionId;

  const MissionActivity({super.key, required this.missionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MissionActivityScreenController(missionId: missionId),
    );

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,

        elevation: 0,

        backgroundColor: Colors.white,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),

          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),

            width: 15,

            height: 15,
          ),
        ),

        title: const Text(
          AppConstants.missionActivityTitle,

          style: TextStyle(
            color: Colors.black,

            fontSize: 14,

            fontWeight: FontWeight.w500,
          ),
        ),

        centerTitle: true,
      ),

      backgroundColor: Colors.white,

      body: Obx(() {
        if (controller.activityController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2A73EA),

              strokeWidth: 2,
            ),
          );
        }

        final activity = controller.activityController.activityData.value;

        if (activity == null) {
          return const Center(
            child: Text(
              AppConstants.failedToLoadActivity,

              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 14, color: Color(0xFF51585C)),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 0, 14, 10),

                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 12),

                    child: Text(
                      AppConstants.activityTimeline,

                      style: TextStyle(
                        fontSize: 15,

                        fontWeight: FontWeight.w600,

                        color: Colors.black87,
                      ),
                    ),
                  ),

                  if (activity.events.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 22),

                      child: Center(
                        child: Text(
                          AppConstants.noActivityYet,

                          style: TextStyle(
                            fontSize: 13,

                            color: Color(0xFF51585C),
                          ),
                        ),
                      ),
                    )
                  else
                    ...activity.events.asMap().entries.map((entry) {
                      final index = entry.key;

                      final event = entry.value;

                      final isLast = index == activity.events.length - 1;

                      return _timelineItem(
                        controller: controller,

                        event: event,

                        isLast: isLast,

                        locationName: activity.locationName,
                      );
                    }),

                  const SizedBox(height: 4),

                  const Text(
                    AppConstants.expertRewards,

                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 16),

                  _rewardTile(
                    title: AppConstants.creditsRewardTitle,

                    value: '${activity.rewards.credits}',

                    subtitle: AppConstants.creditsRewardSubtitle,
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),

                    child: Divider(thickness: 1.5, color: Color(0xFFE0E0E0)),
                  ),

                  const SizedBox(height: 5),

                  _rewardTile(
                    title: AppConstants.reputationRewardTitle,

                    value: '+${activity.rewards.reputation}',

                    subtitle: AppConstants.reputationRewardSubtitle,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(30),

              child: SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) => ViewSubmit(missionId: missionId),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A73EA),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),

                  child: const Text(
                    AppConstants.viewSubmitProof,

                    style: TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.w600,

                      color: Colors.white,
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

  Widget _timelineItem({
    required MissionActivityScreenController controller,

    required MissionActivityEvent event,

    required bool isLast,

    required String locationName,
  }) {
    final innerIcon = controller.assetIconForType(event.type);

    final title = controller.titleForType(event.type);

    final time = controller.formatTime(event.at);

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 52,

            height: 100,

            child: Stack(
              alignment: Alignment.topCenter,

              children: [
                if (!isLast)
                  Positioned(
                    top: 20,

                    bottom: -20,

                    child: Container(
                      width: 1.2,

                      color: const Color(0xFF2A73EA),
                    ),
                  ),

                SizedBox(
                  width: 36,

                  height: 40,

                  child: Stack(
                    alignment: Alignment.center,

                    children: [
                      Image.asset(
                        CommonUi.setPngIcon("circle"),

                        width: 36,

                        height: 36,
                      ),

                      if (innerIcon != null)
                        Image.asset(innerIcon, width: 16, height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        fontWeight: FontWeight.w600,

                        fontSize: 14,
                      ),
                    ),

                    Text(
                      time,

                      style: const TextStyle(
                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Color(0xFF51585C),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  event.description,

                  style: const TextStyle(
                    fontFamily: 'Inter',

                    fontSize: 12,

                    fontWeight: FontWeight.w400,

                    height: 1.0,

                    color: Color(0xFF51585C),
                  ),
                ),

                const SizedBox(height: 6),

                if (event.type == AppConstants.eventTypeProofSubmitted)
                  Row(
                    children: [
                      Image.asset(
                        CommonUi.setPngIcon("photos"),

                        width: 14,

                        height: 14,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '${event.photoCount ?? 0} ${AppConstants.photos}',

                        style: const TextStyle(
                          fontSize: 12,

                          fontWeight: FontWeight.w400,

                          color: Color(0xFF51585C),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Image.asset(
                        CommonUi.setPngIcon("characters"),

                        width: 16,

                        height: 14,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        '${event.notesLength ?? 0} ${AppConstants.characters}',

                        style: const TextStyle(
                          fontSize: 12,

                          fontWeight: FontWeight.w400,

                          color: Color(0xFF51585C),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(width: 8),

                if (event.type == AppConstants.eventTypeCreditApproved &&
                    locationName.isNotEmpty)
                  Row(
                    children: [
                      SizedBox(
                        width: 16,

                        height: 16,

                        child: Stack(
                          alignment: Alignment.center,

                          children: [
                            Image.asset(
                              CommonUi.setPngIcon("location"),

                              width: 16,

                              height: 16,
                            ),

                            Image.asset(
                              CommonUi.setPngIcon("locat"),

                              width: 5,

                              height: 5,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          locationName,

                          style: const TextStyle(
                            fontSize: 12,

                            fontWeight: FontWeight.w400,

                            color: Color(0xFF51585C),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallTagButton(String text) {
    return ElevatedButton(
      onPressed: () {},

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF),

        elevation: 0,

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

        minimumSize: Size.zero,

        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),

          side: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),

      child: Text(
        text,

        style: const TextStyle(
          fontSize: 11,

          fontWeight: FontWeight.w500,

          color: Color(0xFF000000),
        ),
      ),
    );
  }

  Widget _rewardTile({
    required String title,

    required String value,

    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEAF1FF),

            child: Image.asset(
              title == AppConstants.creditsRewardTitle
                  ? CommonUi.setPngIcon("coiny")
                  : CommonUi.setPngIcon("ranking"),

              width: 18,

              height: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                if (title == AppConstants.reputationRewardTitle)
                  Row(
                    children: [
                      _smallTagButton(AppConstants.environment),

                      const SizedBox(width: 6),

                      _smallTagButton(AppConstants.communityEvents),
                    ],
                  )
                else
                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontFamily: 'Inter',

                      fontSize: 12,

                      fontWeight: FontWeight.w400,

                      height: 1.0,

                      color: Color(0xFF51585C),
                    ),
                  ),
              ],
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontSize: 13,

              fontWeight: FontWeight.w400,

              color: Color(0xFF51585C),
            ),
          ),
        ],
      ),
    );
  }
}
