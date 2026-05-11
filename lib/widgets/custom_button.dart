import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isGoogle;
  final bool isApple;
  final bool isLoading;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGoogle = false,
    this.isApple = false,
    this.isLoading = false,
    this.width,
    this.height = 50,
    this.borderRadius = 10,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isGoogle) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton.icon(
          icon: Image.asset("assets/icons/google.png", width: 22, height: 22),
          label: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onPressed: onPressed,
        ),
      );
    }

    if (isApple) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton.icon(
          icon: Image.asset("assets/icons/apple.png", width: 25, height: 25),
          label: const Text(
            "Sign in with Apple",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          onPressed: onPressed,
        ),
      );
    }
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? ColorConstants.blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
