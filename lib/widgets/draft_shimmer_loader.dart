import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class DraftShimmerLoader extends StatelessWidget {
  const DraftShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(top: 0),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER ROW
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // AVATAR
                  ShimmerLoader(
                    height: 44,
                    width: 44,
                    borderRadius: BorderRadius.circular(22),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Name
                            const ShimmerLoader(height: 12, width: 120),
                            const Spacer(),
                            // Draft badge
                            const ShimmerLoader(height: 10, width: 55),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // time · location
                        const ShimmerLoader(height: 10, width: 160),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // DESCRIPTION
            const Padding(
              padding: EdgeInsets.only(left: 68, right: 16),
              child: ShimmerLoader(height: 11, width: double.infinity),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(left: 68, right: 60),
              child: ShimmerLoader(height: 11, width: double.infinity),
            ),

            const SizedBox(height: 4),

            // HASHTAG
            const Padding(
              padding: EdgeInsets.only(left: 68),
              child: ShimmerLoader(height: 10, width: 80),
            ),

            const SizedBox(height: 8),

            // IMAGE placeholder
            Container(
              margin: const EdgeInsets.only(left: 71, right: 16),
              child: ShimmerLoader(
                height: 297,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 20),

            const Divider(color: Color(0xFFEBEBEB), thickness: 1),
          ],
        );
      },
    );
  }
}
