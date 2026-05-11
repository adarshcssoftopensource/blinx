import 'package:app_links/app_links.dart';
import 'package:blinx_mobile/social_pulse_screen/post_detail_screen/view/post_detail_screen.dart';
import 'package:get/get.dart';

class DeepLinkHandler {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> init() async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink);
    }
    _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri);
    });
  }

  static void _handleLink(Uri uri) {
    // URL: https://civicfind-api-staging-.../blinks/cmnka1g06001q17s6ei7l4a2r
    // pathSegments = ['blinks', 'cmnka1g06001q17s6ei7l4a2r']
    final segments = uri.pathSegments;

    if (segments.length >= 2 && segments[0] == 'blinks') {
      final blinkId = segments[1];
      print("Deep Link BlinkId: $blinkId");
      _navigateToBlink(blinkId);
    }
  }

  static void _navigateToBlink(String blinkId) {
    Get.to(
      () => PostDetailScreen(blinkId: blinkId),
      arguments: {'blinkId': blinkId},
    );
  }
}
