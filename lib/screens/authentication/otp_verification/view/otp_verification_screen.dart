import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/otp_verification_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class OtpVerificationScreen extends StatelessWidget {
  final String email;
  final bool? isSignUpTrue;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.isSignUpTrue = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());

    const double singleBoxWidth = 55;
    const double singleBoxHeight = 48;
    const double boxSpacing = 16;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 14,
            width: 14,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 49),
                const Text(
                  AppConstants.otpVerificationTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${AppConstants.otpVerificationSubtitle}($email)",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF51585C),
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 37),
                const Text(
                  AppConstants.enterOtp,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E1A2B),
                  ),
                ),
                const SizedBox(height: 6),

                // OTP boxes
                LayoutBuilder(
                  builder: (context, constraints) {
                    double totalWidth = 6 * singleBoxWidth + 5 * boxSpacing;
                    double scale = 1.0;
                    if (totalWidth > constraints.maxWidth) {
                      scale = constraints.maxWidth / totalWidth;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : boxSpacing * scale,
                          ),
                          child: SizedBox(
                            width: singleBoxWidth * scale,
                            height: singleBoxHeight,
                            child: TextField(
                              controller: controller.otpControllers[index],
                              focusNode: controller.focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                                color: Color(0xFF0E1A2B),
                              ),
                              cursorColor: const Color(0xFF51585C),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD3D3D3),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD3D3D3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD3D3D3),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  controller.focusNodes[index + 1]
                                      .requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  controller.focusNodes[index - 1]
                                      .requestFocus();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),

                const SizedBox(height: 15),

                // Resend OTP
                GestureDetector(
                  onTap: () async {
                    if (!await controller.hasInternet()) {
                      Get.snackbar(
                        AppConstants.noInternet,
                        AppConstants.checkInternet,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    controller.clearOtpFields();
                    controller.authController.resendOTPApi(email);
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppConstants.resendOtp,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                //OTP error
                Obx(
                  () => controller.otpError.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            controller.otpError.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontFamily: "Inter",
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 20),

                Obx(
                  () => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: controller.authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: AppConstants.verifyOtp,
                            color: const Color(0xFF2A73EA),
                            borderRadius: 30,
                            onPressed: () => controller.submitOtp(
                              email,
                              isSignUpTrue ?? false,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
