import 'package:flutter/material.dart';

import '../../../utils/screens/string_constants.dart';

Widget locationPopupCard() {
  return Dialog(
    backgroundColor: Colors.transparent,

    child: Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),

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
            AppConstants.location,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          const Text(
            AppConstants
                .toFindNearbyBlinksWeNeedYourLocationYouCanChangeThisAnytime,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          const SizedBox(height: 18),

          Container(
            height: 42,
            width: 120,

            decoration: BoxDecoration(
              color: const Color(0xFF2A73EA),
              borderRadius: BorderRadius.circular(22),
            ),

            child: const Center(
              child: Text(
                AppConstants.allow,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            AppConstants.notNow,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
