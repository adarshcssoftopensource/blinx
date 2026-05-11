import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/saved_place_model.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';

import '../../../plans/plan_shimmer.dart';

class SavedPlaceCard extends StatelessWidget {
  final SavedPlaceModel place;
  const SavedPlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstants.lighterGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              place.thumbnailUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: ShimmerBox(width: 80, height: 80),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(
                    text: place.name,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.black,
                  ),
                  const SizedBox(height: 4),
                  SmallText(
                    text: place.locationName,
                    fontSize: 12,
                    color: ColorConstants.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
