import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class NewPlanShimmer extends StatelessWidget {
  const NewPlanShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),

          // Title label
          ShimmerLoader(height: 13, width: 50),
          const SizedBox(height: 8),
          ShimmerLoader(
            height: 48,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 20),

          // Summary label
          ShimmerLoader(height: 13, width: 70),
          const SizedBox(height: 8),
          ShimmerLoader(
            height: 90,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 20),

          // Dates label
          ShimmerLoader(height: 13, width: 50),
          const SizedBox(height: 8),
          ShimmerLoader(
            height: 48,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 20),

          // Place label
          ShimmerLoader(height: 13, width: 50),
          const SizedBox(height: 8),
          ShimmerLoader(
            height: 48,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 20),

          // Status label
          ShimmerLoader(height: 13, width: 55),
          const SizedBox(height: 8),
          ShimmerLoader(
            height: 48,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 32),

          // Save button
          ShimmerLoader(
            height: 50,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
