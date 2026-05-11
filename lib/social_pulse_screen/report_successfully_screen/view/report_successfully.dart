import 'package:blinx_mobile/social_pulse_screen/home_screen/view/home_screen.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 373,
        height: 257,

        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 47, 16, 30),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: Color(0xFF2A73EA), size: 50),

              const SizedBox(height: 16),

              const Text(
                AppConstants.reportedSuccessfully,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Get.offAll(() => HomeScreen());
                },

                child: Container(
                  width: 160,
                  height: 45,

                  decoration: BoxDecoration(
                    color: const Color(0xFF2A73EA),
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: const Center(
                    child: Text(
                      AppConstants.backToHome,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
