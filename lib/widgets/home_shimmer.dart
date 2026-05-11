import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                ShimmerLoader(
                  height: 40,
                  width: 40,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                SizedBox(width: 10),
                ShimmerLoader(height: 10, width: 120),
              ],
            ),
            const SizedBox(height: 10),
            const ShimmerLoader(height: 200, width: double.infinity),
            const SizedBox(height: 10),
            const ShimmerLoader(height: 10, width: 200),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
