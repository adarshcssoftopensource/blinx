import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:flutter/material.dart';

class FullScreenPhotos extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const FullScreenPhotos({required this.photos, required this.initialIndex});

  @override
  State<FullScreenPhotos> createState() => FullScreenPhotosState();
}

class FullScreenPhotosState extends State<FullScreenPhotos> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 15,
            width: 15,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                widget.photos[index],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 48,
                ),
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
