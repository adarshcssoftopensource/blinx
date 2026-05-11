import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum MarketplaceCardType { text, image, video }

class MarketplaceListShimmer extends StatelessWidget {
  final int itemCount;
  final MarketplaceCardType cardType;

  const MarketplaceListShimmer({
    super.key,
    this.itemCount = 5,
    this.cardType = MarketplaceCardType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: _buildCard(),
      ),
    );
  }

  Widget _buildCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Video thumbnail
              if (cardType == MarketplaceCardType.image)
                _shimmerBox(double.infinity, 160, radius: 10),
              if (cardType == MarketplaceCardType.video)
                _videoThumbnailShimmer(),
              if (cardType != MarketplaceCardType.text)
                const SizedBox(height: 12),

              // Status badge + Credits row
              Row(
                children: [
                  _shimmerBox(72, 22, radius: 12),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _shimmerBox(54, 16),
                      const SizedBox(height: 4),
                      _shimmerBox(80, 12),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              _shimmerBox(double.infinity * 0.65, 16),
              const SizedBox(height: 6),

              // Description lines
              _shimmerBox(double.infinity, 12),
              const SizedBox(height: 5),
              _shimmerBox(double.infinity * 0.85, 12),
              const SizedBox(height: 12),

              // Type + Button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(60, 12),
                  _shimmerBox(90, 34, radius: 20),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const Divider(thickness: 0.4, color: Colors.grey, height: 0),
      ],
    );
  }

  Widget _shimmerBox(double width, double height, {double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _videoThumbnailShimmer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _shimmerBox(double.infinity, 160, radius: 10),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
        ),
      ],
    );
  }
}
