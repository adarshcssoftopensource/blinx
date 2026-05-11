import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class SharedPlansShimmer extends StatelessWidget {
  const SharedPlansShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(
            color: ColorConstants.lighterGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ShimmerLoader(
                  height: 48,
                  width: 48,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoader(height: 14, width: 160),
                      const SizedBox(height: 6),
                      ShimmerLoader(height: 12, width: 100),
                      const SizedBox(height: 6),
                      ShimmerLoader(height: 12, width: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
