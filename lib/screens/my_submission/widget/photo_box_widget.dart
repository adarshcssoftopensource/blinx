import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:flutter/material.dart';

import 'full_screen_photo_widget.dart';

Widget submissionPhotosBox(BuildContext context, List<String> photos) {
  final displayPhotos = photos.take(5).toList();

  if (displayPhotos.isEmpty) return const SizedBox.shrink();

  if (displayPhotos.length == 1) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FullScreenPhotos(photos: displayPhotos, initialIndex: 0),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          displayPhotos.first,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 200,
          errorBuilder: (_, __, ___) => Container(
            height: 200,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final gridWidth = constraints.maxWidth;
      final halfWidth = (gridWidth - 8) / 2;

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(displayPhotos.length, (index) {
          bool isLastOdd =
              displayPhotos.length.isOdd && index == displayPhotos.length - 1;

          double width = isLastOdd ? gridWidth : halfWidth;
          double height = 120;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenPhotos(
                    photos: displayPhotos,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                displayPhotos[index],
                fit: BoxFit.cover,
                width: width,
                height: height,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return ShimmerLoader(
                    height: height,
                    width: width,
                    borderRadius: BorderRadius.circular(12),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}
