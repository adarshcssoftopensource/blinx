import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class UpcomingPlacesShimmer extends StatelessWidget {
  const UpcomingPlacesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ColorConstants.lighterGreyColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoader(height: 14, width: 160),
                      const SizedBox(height: 8),
                      ShimmerLoader(height: 12, width: 130),
                      const SizedBox(height: 6),
                      ShimmerLoader(height: 12, width: 80),
                    ],
                  ),
                ),
                ShimmerLoader(
                  height: 16,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
