import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenPhotosController extends GetxController {
  final int initialIndex;

  FullScreenPhotosController({required this.initialIndex});

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: initialIndex);
  }

  @override
  void onClose() {
    pageController.dispose();

    super.onClose();
  }
}
