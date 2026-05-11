import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

class SavedPlacesShimmer extends StatelessWidget {
  const SavedPlacesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              ShimmerLoader(
                height: 50,
                width: 50,
                borderRadius: BorderRadius.circular(6),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(height: 13, width: 140),
                    SizedBox(height: 6),
                    ShimmerLoader(height: 11, width: 100),
                  ],
                ),
              ),

              // ShimmerLoader(height: 24, width: 24, borderRadius: 12),
              ShimmerLoader(
                height: 24,
                width: 24,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        );
      },
    );
  }
}
