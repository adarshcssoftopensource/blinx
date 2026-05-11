import 'package:flutter/material.dart';

Widget actionBox(
  IconData icon,
  String count, {
  bool isActive = false,
  VoidCallback? onTap,
  String? imagePath,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(15.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          imagePath != null
              ? Image.asset(imagePath, width: 14, height: 14)
              : Icon(
                  icon,
                  size: 14,
                  color: isActive ? Colors.red : Colors.black,
                ),

          const SizedBox(width: 4),

          Text(
            count,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
