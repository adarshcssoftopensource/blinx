import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class NearbyShimmerLoader extends StatelessWidget {
  const NearbyShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(top: 6),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER — avatar + name + time + distance
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // Avatar circle with border
                  ShimmerLoader(
                    height: 48,
                    width: 48,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name row + verified
                        Row(
                          children: [
                            ShimmerLoader(height: 12, width: 120),
                            const Spacer(),
                            ShimmerLoader(height: 10, width: 60),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // time · distance
                        ShimmerLoader(height: 10, width: 160),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT lines
            const Padding(
              padding: EdgeInsets.only(left: 75, right: 16),
              child: ShimmerLoader(height: 11, width: double.infinity),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(left: 75, right: 60),
              child: ShimmerLoader(height: 11, width: double.infinity),
            ),

            const SizedBox(height: 4),

            // HASHTAG
            const Padding(
              padding: EdgeInsets.only(left: 75),
              child: ShimmerLoader(height: 10, width: 80),
            ),

            const SizedBox(height: 8),

            // IMAGE placeholder
            Container(
              margin: const EdgeInsets.only(left: 68, right: 16),
              child: ShimmerLoader(
                height: 230,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 10),

            // ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.only(left: 68, right: 16),
              child: Row(
                children: [
                  ShimmerLoader(
                    height: 31,
                    width: 51,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(width: 8),
                  ShimmerLoader(
                    height: 31,
                    width: 51,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(width: 8),
                  ShimmerLoader(
                    height: 31,
                    width: 51,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Divider(color: Color(0xFFEBEBEB), thickness: 1),
          ],
        );
      },
    );
  }
}
