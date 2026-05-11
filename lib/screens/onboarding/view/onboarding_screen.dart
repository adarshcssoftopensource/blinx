import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < -150)
                controller.nextPage();
              else if (details.primaryVelocity! > 150)
                controller.previousPage();
            }
          },
          child: Obx(() {
            final index = controller.currentIndex.value;
            final isLast = index == controller.onboardingData.length - 1;
            final current = controller.onboardingData[index];

            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: index == 1 ? screenHeight * 0.22 : screenHeight * 0.13,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: index == 1 ? 16 : 0,
                    ),
                    child: Image.asset(
                      current['image']!,
                      fit: BoxFit.contain,
                      width: screenWidth,
                    ),
                  ),
                ),

                Positioned(
                  top: screenHeight * 0.68,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: screenWidth * 0.82,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            current['title']!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            current['desc']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff51585C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          !isLast
                              ? TextButton(
                                  onPressed: controller.skip,
                                  child: const Text(
                                    'Skip',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const SizedBox(width: 70, height: 50),

                          Row(
                            children: List.generate(
                              controller.onboardingData.length,
                              (i) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: index == i ? 8 : 6,
                                height: index == i ? 8 : 6,
                                decoration: BoxDecoration(
                                  color: index == i
                                      ? const Color(0xff2A73EA)
                                      : Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          ElevatedButton(
                            onPressed: controller.nextPageOnTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2A73EA),
                              minimumSize: Size(
                                isLast ? 76 : 75,
                                screenHeight * 0.05,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text(
                              isLast ? 'Finish' : 'Next',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
