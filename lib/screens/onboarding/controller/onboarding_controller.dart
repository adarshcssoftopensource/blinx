import 'package:get/get.dart';

import '../../../utils/screens/image_constants.dart';
import '../../authentication/sign_in/view/sign_in_screen.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;

  final List<Map<String, String>> onboardingData = [
    {
      'image': ImageConstants.image1,
      'title': 'Share Local Updates',
      'desc':
          'Instantly post what\'s happening around you. Keep your community informed and connected.',
    },
    {
      'image': ImageConstants.image2,
      'title': 'Discover Nearby Info',
      'desc':
          'Explore a live feed of events, news, and alerts happening right in your neighborhood.',
    },
    {
      'image': ImageConstants.image3,
      'title': 'Contribute to Awareness',
      'desc':
          'Your posts help build a safer, more aware community. Be the eyes and ears of your area.',
    },
  ];

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) currentIndex++;
  }

  void previousPage() {
    if (currentIndex.value > 0) currentIndex--;
  }

  void nextPageOnTap() {
    if (currentIndex.value < onboardingData.length - 1) {
      currentIndex++;
    } else {
      Get.off(() => const SignInScreen());
    }
  }

  void skip() {
    Get.off(() => const SignInScreen());
  }
}
