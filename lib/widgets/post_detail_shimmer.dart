import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class PostDetailShimmer extends StatelessWidget {
  const PostDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER (Avatar + Name + Verified)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ShimmerLoader(
                height: 44,
                width: 44,
                borderRadius: BorderRadius.circular(100),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Verified
                    Row(
                      children: [
                        const ShimmerLoader(height: 14, width: 120),
                        const Spacer(),
                        ShimmerLoader(
                          height: 14,
                          width: 60,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Time + Location
                    const ShimmerLoader(height: 12, width: 180),
                    const SizedBox(height: 8),

                    // Content lines
                    const ShimmerLoader(height: 12, width: double.infinity),
                    const SizedBox(height: 6),
                    const ShimmerLoader(height: 12, width: double.infinity),
                    const SizedBox(height: 6),
                    const ShimmerLoader(height: 12, width: 200),

                    const SizedBox(height: 8),

                    // Hashtag
                    const ShimmerLoader(height: 12, width: 100),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // IMAGE / VIDEO
          ShimmerLoader(
            height: 260,
            width: double.infinity,
            borderRadius: BorderRadius.circular(14),
          ),

          const SizedBox(height: 12),

          // ACTION CHIPS
          Row(
            children: [
              _chip(),
              const SizedBox(width: 10),
              _chip(),
              const SizedBox(width: 10),
              _chip(),
            ],
          ),

          const SizedBox(height: 20),

          // RELATED TOPICS TITLE
          const ShimmerLoader(height: 14, width: 150),
          const SizedBox(height: 12),

          // TOPIC LIST
          ...List.generate(3, (index) {
            return Column(
              children: [
                Row(
                  children: [
                    const ShimmerLoader(height: 12, width: 120),
                    const Spacer(),
                    const ShimmerLoader(height: 12, width: 60),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: Colors.black12),
                const SizedBox(height: 12),
              ],
            );
          }),

          const SizedBox(height: 30),

          // BUTTONS
          Row(
            children: [
              Expanded(
                child: ShimmerLoader(
                  height: 44,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShimmerLoader(
                  height: 44,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _chip() {
    return ShimmerLoader(
      height: 28,
      width: 70,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
