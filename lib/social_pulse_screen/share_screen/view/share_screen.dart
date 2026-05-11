import 'package:blinx_mobile/social_pulse_screen/share_screen/widget/share_icon.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/share_controller.dart';

class ShareScreen extends StatelessWidget {
  final String blinkId;

  const ShareScreen({super.key, required this.blinkId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShareController(blinkId: blinkId), tag: blinkId);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              AppConstants.shareBlink,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          const Text(
            AppConstants.shareVia,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 12),

          Obx(() {
            if (controller.isLoadingLinks.value) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.fetchError.isNotEmpty &&
                controller.shareLinksModel.value == null) {
              final bool isPrivate = controller.fetchError.value
                  .toLowerCase()
                  .contains('private');

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPrivate ? Icons.lock_outline : Icons.wifi_off_rounded,
                      size: 36,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.fetchError.value,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!isPrivate) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: controller.retryFetchShareLinks,
                        child: const Text(AppConstants.retry),
                      ),
                    ],
                  ],
                ),
              );
            }

            final bool busy = controller.isSharing.value;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ShareIcon(
                      icon: Icons.message,
                      text: AppConstants.whatsapp,
                      color: const Color(0xFF25D366),
                      onTap: busy
                          ? null
                          : () => controller.shareBlink(SharePlatform.whatsapp),
                    ),
                    ShareIcon(
                      icon: Icons.facebook,
                      text: AppConstants.facebook,
                      color: const Color(0xFF1877F2),
                      onTap: busy
                          ? null
                          : () => controller.shareBlink(SharePlatform.facebook),
                    ),
                    ShareIcon(
                      icon: Icons.link,
                      text: AppConstants.copyLink,
                      color: Colors.black,
                      onTap: busy
                          ? null
                          : () => controller.shareBlink(SharePlatform.copyLink),
                    ),
                    ShareIcon(
                      icon: Icons.camera_alt,
                      text: AppConstants.instagram,
                      color: const Color(0xFFE4405F),
                      onTap: busy
                          ? null
                          : () =>
                                controller.shareBlink(SharePlatform.instagram),
                    ),
                    ShareIcon(
                      icon: Icons.alternate_email,
                      text: AppConstants.twitter,
                      color: Colors.black,
                      onTap: busy
                          ? null
                          : () => controller.shareBlink(SharePlatform.twitter),
                    ),
                  ],
                ),
                if (busy)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
