import 'package:flutter/material.dart';

import '../../../utils/screens/string_constants.dart';

Widget bluetoothPopupCard() {
  return Dialog(
    backgroundColor: Colors.transparent,

    child: Container(
      width: 372,
      height: 200,

      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          const Icon(Icons.bluetooth, size: 22),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: const [
                Text(
                  AppConstants.bluetooth,

                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 3),

                Text(
                  AppConstants
                      .enableBluetoothToDetectNearbyBlinksAndSendProximityAlerts,

                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          Switch(
            value: true,
            onChanged: (v) {},
            activeColor: const Color(0xFF34C759),
          ),
        ],
      ),
    ),
  );
}
