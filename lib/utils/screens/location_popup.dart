import 'package:blinx_mobile/map/blinx_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget locationPopupCard({VoidCallback? onAllow}) {
  return Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      width: 373,
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, size: 42, color: Color(0xFF2A73EA)),
          const SizedBox(height: 12),
          const Text(
            "Location",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          const Text(
            "To find nearby Blinks, we need your Location. You can change this anytime.",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF51585C),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Get.back();
              if (onAllow != null) {
                onAllow();
              } else {
                Get.to(() => BlinxMapScreen());
              }
            },
            child: Container(
              height: 42,
              width: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2A73EA),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: Text(
                  "Allow",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Get.back(),
            child: const Text(
              "Not Now",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    ),
  );
}
