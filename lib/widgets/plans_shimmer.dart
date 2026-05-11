import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class PlansShimmer extends StatelessWidget {
  const PlansShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.white2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(height: 13, width: 160),
                    const SizedBox(height: 6),
                    ShimmerLoader(height: 11, width: 120),
                    const SizedBox(height: 6),
                    ShimmerLoader(height: 11, width: 80),
                  ],
                ),
              ),
              ShimmerLoader(
                height: 18,
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      },
    );
  }
}
