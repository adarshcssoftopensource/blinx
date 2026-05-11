import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:blinx_mobile/social_pulse_screen/post_detail_screen/view/post_detail_screen.dart';
import 'package:get/get.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription? _sub;

  Future<void> init() async {
    final Uri? initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    _sub = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (err) => print("Deep link error: $err"),
    );
  }

  void _handleUri(Uri uri) {
    final segments = uri.pathSegments;

    if (segments.length >= 2 && segments[0] == 'blinks') {
      final blinkId = segments[1];
      Get.to(() => PostDetailScreen(blinkId: blinkId));
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
