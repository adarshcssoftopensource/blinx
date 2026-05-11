import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class MarketplaceDetailShimmer extends StatelessWidget {
  const MarketplaceDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TASK & APPLICANT CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9EDF2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task title
                const ShimmerLoader(height: 16, width: double.infinity),
                const SizedBox(height: 6),
                const ShimmerLoader(height: 14, width: 200),
                const SizedBox(height: 8),

                // Published date row
                Row(
                  children: [
                    ShimmerLoader(
                      height: 16,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 6),
                    const ShimmerLoader(height: 12, width: 120),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 8),
                const SizedBox(height: 12),

                // Applicant row
                Row(
                  children: [
                    ShimmerLoader(
                      height: 36,
                      width: 36,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerLoader(height: 12, width: 140),
                        SizedBox(height: 6),
                        ShimmerLoader(height: 10, width: 100),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Proof of Work title
          const ShimmerLoader(height: 15, width: 120),
          const SizedBox(height: 12),

          // PHOTOS GRID
          LayoutBuilder(
            builder: (context, constraints) {
              final halfWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 11,
                children: [
                  ShimmerLoader(
                    height: 130,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  ShimmerLoader(
                    height: 130,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  ShimmerLoader(
                    height: 130,
                    width: halfWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  ShimmerLoader(
                    height: 130,
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

          const SizedBox(height: 18),

          // Definition of Done title
          const ShimmerLoader(height: 15, width: 150),
          const SizedBox(height: 8),
          const ShimmerLoader(height: 12, width: double.infinity),
          const SizedBox(height: 6),
          const ShimmerLoader(height: 12, width: double.infinity),
          const SizedBox(height: 6),
          const ShimmerLoader(height: 12, width: 220),

          const SizedBox(height: 18),

          // REWARD CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9EDF2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoader(height: 14, width: 140),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(height: 10, width: 80),
                        SizedBox(height: 6),
                        ShimmerLoader(height: 12, width: 100),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Approve/Reject section
          const ShimmerLoader(height: 15, width: 100),
          const SizedBox(height: 8),
          ShimmerLoader(
            height: 118,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 40),

          // Buttons
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerLoader(
                  height: 50,
                  width: 138,
                  borderRadius: BorderRadius.circular(100),
                ),
                const SizedBox(width: 12),
                ShimmerLoader(
                  height: 50,
                  width: 119,
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
