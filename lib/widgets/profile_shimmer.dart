import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.015),

          // Avatar circle
          Center(
            child: ShimmerLoader(
              height: screenWidth * 0.29,
              width: screenWidth * 0.29,
              // borderRadius: screenWidth * 0.145,
            ),
          ),

          SizedBox(height: screenHeight * 0.015),

          // Name
          Center(child: ShimmerLoader(height: 18, width: 140)),
          SizedBox(height: 8),

          // Member label
          Center(child: ShimmerLoader(height: 12, width: 60)),

          SizedBox(height: screenHeight * 0.022),

          // Email label
          ShimmerLoader(height: 12, width: 100),
          SizedBox(height: screenHeight * 0.004),

          // Email value
          ShimmerLoader(height: 12, width: 200),

          SizedBox(height: screenHeight * 0.027),
          Container(height: 1, color: Colors.black12),
          SizedBox(height: screenHeight * 0.02),

          // Tabs row
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index != 2 ? 6 : 0),
                  child: ShimmerLoader(height: 36, width: double.infinity),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 18),

          // Section cards
          ...List.generate(
            6,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShimmerLoader(height: 60, width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
