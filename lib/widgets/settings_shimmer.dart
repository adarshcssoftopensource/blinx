import 'package:flutter/material.dart';

import 'shimmer_loader.dart';

class SettingsShimmer extends StatelessWidget {
  const SettingsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: const [
              ShimmerLoader(
                height: 40,
                width: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              SizedBox(width: 12),
              ShimmerLoader(height: 12, width: 150),
            ],
          ),
        );
      },
    );
  }
}
