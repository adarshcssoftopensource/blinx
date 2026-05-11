import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class PlanDetailShimmer extends StatelessWidget {
  const PlanDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                // Image placeholder
                ShimmerLoader(
                  height: 58,
                  width: 58,
                  borderRadius: BorderRadius.circular(8),
                ),

                const SizedBox(width: 14),

                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoader(height: 13, width: 140),
                      const SizedBox(height: 6),
                      ShimmerLoader(height: 11, width: 100),
                      const SizedBox(height: 10),
                      ShimmerLoader(
                        height: 22,
                        width: 70,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Check icon placeholder
                ShimmerLoader(
                  height: 20,
                  width: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
