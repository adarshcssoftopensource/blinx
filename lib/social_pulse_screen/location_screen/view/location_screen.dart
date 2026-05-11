import 'package:blinx_mobile/map/blinx_map_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/screens/string_constants.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        titleSpacing: 14,
        title: Image.asset(
          CommonUi.setPngIcon("blinx"),
          width: 78,
          height: 34,
          fit: BoxFit.contain,
        ),
      ),

      body: Stack(
        children: [
          // NON-BLOCKING OVERLAY
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

          // MAIN CONTENT
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 48,
                      color: Color(0xFF2A73EA),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      AppConstants.location,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      AppConstants
                          .toFindNearbyBlinksWeNeedYourLocationYouCanChangeThisAnytime,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // BUTTON NOW
                    SizedBox(
                      width: 140,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => BlinxMapScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A73EA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          AppConstants.allow,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text(
                        AppConstants.notNow,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
