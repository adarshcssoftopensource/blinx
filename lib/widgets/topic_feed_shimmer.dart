import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class TopicFeedShimmer extends StatelessWidget {
  const TopicFeedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerLoader(height: 120, width: double.infinity),
            SizedBox(height: 8),
            ShimmerLoader(height: 10, width: 100),
            SizedBox(height: 6),
            ShimmerLoader(height: 10, width: 60),
          ],
        );
      },
    );
  }
}
