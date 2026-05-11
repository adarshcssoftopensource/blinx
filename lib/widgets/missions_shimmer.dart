import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class MissionsShimmer extends StatelessWidget {
  const MissionsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerLoader(height: 12, width: 150),
              SizedBox(height: 8),
              ShimmerLoader(height: 10, width: double.infinity),
              SizedBox(height: 8),
              ShimmerLoader(height: 10, width: 200),
              SizedBox(height: 12),
              ShimmerLoader(height: 30, width: 100),
            ],
          ),
        );
      },
    );
  }
}
