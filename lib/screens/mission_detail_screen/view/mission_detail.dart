import 'package:blinx_mobile/screens/profile/edit_profile/edit_profile.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/mission_detail_screen_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class MissionDetail extends StatelessWidget {
  final String missionId;

  const MissionDetail({super.key, required this.missionId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MissionDetailScreenController(missionId: missionId),
    );

    final authController = controller.authController;

    final missionController = controller.missionController;

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

            width: 15,

            height: 15,
          ),
        ),

        title: const Text(
          AppConstants.missionDetailTitle,

          style: TextStyle(
            fontSize: 14,

            fontWeight: FontWeight.w500,

            color: Colors.black,
          ),
        ),

        centerTitle: true,
      ),

      body: Obx(() {
        if (missionController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2A73EA),

              strokeWidth: 2,
            ),
          );
        }

        final mission = missionController.missionDetail.value;

        if (mission == null) {
          return const Center(
            child: Text(
              AppConstants.failedToLoadMission,

              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 14, color: Color(0xFF51585C)),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),

                child: Row(
                  children: [
                    _tabButton(AppConstants.tabCommunity, true),

                    const SizedBox(width: 12),

                    _tabButton(AppConstants.tabWeekly, false),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            mission.title,

                            style: const TextStyle(
                              fontSize: 16,

                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 2),

                          const Row(
                            children: [
                              Icon(
                                Icons.access_time,

                                size: 14,

                                color: Color(0xFF2A73EA),
                              ),

                              SizedBox(width: 4),

                              Text(
                                AppConstants.postedTimeAgo,

                                style: TextStyle(
                                  fontSize: 14,

                                  fontWeight: FontWeight.w400,

                                  color: Color(0xFF51585C),
                                ),
                              ),

                              SizedBox(width: 12),

                              Icon(
                                Icons.remove_red_eye,

                                size: 14,

                                color: Color(0xFF2A73EA),
                              ),

                              SizedBox(width: 4),

                              Text(
                                AppConstants.viewsCount,

                                style: TextStyle(
                                  fontSize: 14,

                                  fontWeight: FontWeight.w400,

                                  color: Color(0xFF51585C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Image.asset(
                      CommonUi.setPngIcon("featured"),

                      width: 80,

                      height: 29,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,

                height: 1.0,

                color: const Color(0xFFE0E0E0),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),

                child: _sectionTitle(AppConstants.sectionLocation),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _infoTile(
                      icon: Icons.location_on,

                      title: mission.locationName,

                      subtitle: mission.locationAddress,
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.only(left: 26),

                      child: ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A73EA),

                          elevation: 0,

                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),

                          minimumSize: const Size(98, 27),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            SizedBox(width: 6),

                            Text(
                              AppConstants.viewOnMap,

                              style: TextStyle(
                                fontSize: 12,

                                fontWeight: FontWeight.w500,

                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,

                height: 1.0,

                color: const Color(0xFFE0E0E0),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Row(
                  children: [
                    Expanded(
                      child: _miniInfo(
                        icon: Icons.schedule,

                        title: AppConstants.sectionDuration,

                        value: mission.duration,
                      ),
                    ),

                    Expanded(
                      child: _miniInfo(
                        icon: Icons.bar_chart,

                        title: AppConstants.sectionDifficulty,

                        value: mission.difficulty,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                height: 1.2,

                color: const Color(0xFFE0E0E0),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: _sectionTitle(AppConstants.sectionRewards),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  children: [
                    _rewardRow(
                      CommonUi.setPngIcon("first"),

                      AppConstants.sectionCredits,

                      mission.credits.toString(),

                      showDivider: true,
                    ),

                    _rewardRow(
                      CommonUi.setPngIcon("second"),

                      AppConstants.sectionCommunityRep,

                      mission.reputation.toString(),

                      showDivider: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: _sectionTitle(AppConstants.sectionRequirements),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _checkItem(
                      AppConstants.requirementProfileComplete,

                      mission.profileComplete
                          ? null
                          : AppConstants.requirementProfileCompleteSubtitle,

                      'assets/icons/prof.png',

                      0,
                    ),

                    const SizedBox(height: 18),

                    _checkItem(AppConstants.requirementAge, null, null, 12),

                    const SizedBox(height: 18),

                    _checkItem(
                      AppConstants.requirementBackgroundCheck,

                      mission.backgroundCheck
                          ? null
                          : AppConstants.requirementBackgroundCheckSubtitle,

                      null,

                      12,
                    ),

                    const SizedBox(height: 18),

                    _checkItem(
                      AppConstants.requirementPhysicalCapable,

                      mission.physicalCapable
                          ? null
                          : AppConstants.requirementPhysicalCapableSubtitle,

                      null,

                      12,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,

                height: 1.2,

                color: const Color(0xFFE0E0E0),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: _infoBox(
                  icon: Icons.camera_alt,

                  title: AppConstants.photoRequired,

                  subtitle:
                      'Minimum ${mission.minPhotos} photo${mission.minPhotos > 1 ? 's' : ''} showing your participation',
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: _infoBox(
                  icon: Icons.note_alt,

                  title: AppConstants.notesRequired,

                  subtitle:
                      'Minimum ${mission.minNotesLength} characters describing your experience',
                ),
              ),

              const SizedBox(height: 14),

              Obx(
                () =>
                    (!authController.profileComplete.value || !mission.canClaim)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),

                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/lock.png',

                              width: 20,

                              height: 20,
                            ),

                            const SizedBox(width: 8),

                            const Expanded(
                              child: Text(
                                AppConstants.completeProfileToClaim,

                                style: TextStyle(
                                  fontSize: 13,

                                  fontWeight: FontWeight.w500,

                                  color: Color(0xFF51585C),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: SizedBox(
                  width: double.infinity,

                  height: 48,

                  child: Obx(() {
                    final canClaim =
                        authController.profileComplete.value &&
                        mission.canClaim;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canClaim
                            ? const Color(0xFF2A73EA)
                            : const Color(0xFFBDBDBD),

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),

                      onPressed: canClaim && !missionController.isClaiming.value
                          ? () => missionController.claimMission(missionId)
                          : null,

                      child: missionController.isClaiming.value
                          ? const SizedBox(
                              width: 20,

                              height: 20,

                              child: CircularProgressIndicator(
                                color: Colors.white,

                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              canClaim
                                  ? AppConstants.claimNow
                                  : AppConstants.completeProfileToClaimBtn,

                              style: const TextStyle(
                                fontSize: 14,

                                fontWeight: FontWeight.w600,

                                color: Colors.white,
                              ),
                            ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 12),

              Obx(() {
                final canClaim =
                    authController.profileComplete.value && mission.canClaim;

                if (canClaim) return const SizedBox.shrink();

                return Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
                      );
                    },

                    child: const Text(
                      AppConstants.saveForLater,

                      style: TextStyle(color: Color(0xFF51585C)),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  static Widget _tabButton(String text, bool active) {
    return SizedBox(
      height: 32,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFFFF),

          side: const BorderSide(color: Color(0xFFE4E4E4)),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          elevation: 0,
        ),

        onPressed: () {},

        child: Text(
          text,

          style: const TextStyle(
            fontSize: 12,

            fontWeight: FontWeight.w500,

            color: Color(0xFF000000),
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Text(
      text,

      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  static Widget _infoTile({
    required IconData icon,

    required String title,

    required String subtitle,

    Widget? trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),

          child: SizedBox(
            width: 18,

            height: 18,

            child: Stack(
              alignment: Alignment.center,

              children: [
                Image.asset(
                  CommonUi.setPngIcon("location"),

                  width: 18,

                  height: 20,
                ),

                Image.asset(CommonUi.setPngIcon("locat"), width: 6, height: 8),
              ],
            ),
          ),
        ),

        const SizedBox(width: 3),

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

                style: const TextStyle(fontSize: 12, color: Color(0xFF51585C)),
              ),
            ],
          ),
        ),

        if (trailing != null) trailing,
      ],
    );
  }

  static Widget _miniInfo({
    required IconData icon,

    required String title,

    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            fontSize: 14,

            fontWeight: FontWeight.w600,

            color: Color(0xFF000000),
          ),
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF2A73EA)),

            const SizedBox(width: 6),

            Text(
              value,

              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _rewardRow(
    String assetIcon,

    String title,

    String value, {

    bool showDivider = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Image.asset(assetIcon, width: 40, height: 40),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        fontSize: 13,

                        fontWeight: FontWeight.w500,

                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      value,

                      style: const TextStyle(
                        fontSize: 12,

                        fontWeight: FontWeight.w400,

                        color: Color(0xFF51585C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(top: 6),

              child: Container(
                width: double.infinity,

                height: 1.0,

                color: const Color(0xFFE0E0E0),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _checkItem(
    String title, [

    String? subtitle,

    String? assetIcon,

    double iconPadding = 0,
  ]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: EdgeInsets.only(left: iconPadding),

          child: assetIcon != null
              ? Image.asset(assetIcon, width: 36, height: 36)
              : Container(
                  width: 16,

                  height: 16,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: Colors.white,

                    border: Border.all(
                      color: const Color(0xFF2A73EA),

                      width: 1.6,
                    ),
                  ),

                  child: const Center(
                    child: Icon(
                      Icons.check,

                      size: 12,

                      color: Color(0xFF2A73EA),
                    ),
                  ),
                ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 13,

                  fontWeight: FontWeight.w500,
                ),
              ),

              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),

                  child: Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 12,

                      color: Color(0xFF51585C),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _infoBox({
    required IconData icon,

    required String title,

    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),

      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2A73EA)),

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
