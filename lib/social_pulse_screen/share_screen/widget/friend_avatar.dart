import 'package:flutter/material.dart';

class FriendAvatar extends StatelessWidget {
  final String image;
  final String name;
  final bool isSelected;

  const FriendAvatar({
    super.key,
    required this.image,
    required this.name,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 22, backgroundImage: AssetImage(image)),
              if (isSelected)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
