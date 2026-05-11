// ─── MissionCard ──────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../utils/screens/image_constants.dart';
import '../../../utils/screens/string_constants.dart';
import '../../mission_detail_screen/view/mission_detail.dart';
import '../../submit_proof_screen/view/submit_proof.dart';
import '../../view_submit_screen/view/view_submit.dart';

class MissionCard extends StatelessWidget {
  final String title;

  final String description;

  final String price;

  final String missionId;

  final bool isSubmitted;

  final bool isActive;

  final bool isCompleted;

  const MissionCard({
    super.key,

    required this.title,

    required this.description,

    required this.price,

    required this.missionId,

    this.isSubmitted = false,

    this.isActive = false,

    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 4),

          Text(
            description,

            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          const Divider(height: 1, thickness: 1),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  Image.asset(
                    CommonUi.setPngIcon("credits"),

                    width: 22,

                    height: 22,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    price,

                    style: const TextStyle(
                      fontSize: 14,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  if (isSubmitted || isCompleted) {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => ViewSubmit(missionId: missionId),
                      ),
                    );
                  } else if (isActive) {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => SubmitProofScreen(
                          applicationId: missionId,

                          missionId: missionId,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => MissionDetail(missionId: missionId),
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A73EA),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),

                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),

                  minimumSize: const Size(0, 27),
                ),

                child: Text(
                  (isSubmitted || isCompleted)
                      ? AppConstants.viewSubmission
                      : isActive
                      ? AppConstants.submitProofBtn
                      : AppConstants.startBtn,

                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
