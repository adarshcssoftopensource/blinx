import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class MySubmissionShimmer extends StatelessWidget {
  const MySubmissionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // MISSION CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12, width: 0.9),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      const ShimmerLoader(height: 14, width: double.infinity),
                      const SizedBox(height: 6),
                      const ShimmerLoader(height: 12, width: 120),
                      const SizedBox(height: 4),
                      const ShimmerLoader(height: 12, width: 80),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Status badge
                ShimmerLoader(
                  height: 28,
                  width: 80,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Definition of Done title
          const ShimmerLoader(height: 14, width: 160),
          const SizedBox(height: 8),
          const ShimmerLoader(height: 11, width: double.infinity),
          const SizedBox(height: 6),
          const ShimmerLoader(height: 11, width: double.infinity),
          const SizedBox(height: 6),
          const ShimmerLoader(height: 11, width: 200),

          const SizedBox(height: 18),

          // Proof of Work title
          const ShimmerLoader(height: 14, width: 120),
          const SizedBox(height: 8),

          // PHOTOS GRID
          LayoutBuilder(
            builder: (context, constraints) {
              final halfWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ShimmerLoader(
                    height: 120,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  ShimmerLoader(
                    height: 120,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  ShimmerLoader(
                    height: 120,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  ShimmerLoader(
                    height: 120,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 8),

          // VIDEO THUMBNAIL
          ShimmerLoader(
            height: 200,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 120),

          // BUTTON
          Center(
            child: ShimmerLoader(
              height: 54,
              width: 176,
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
