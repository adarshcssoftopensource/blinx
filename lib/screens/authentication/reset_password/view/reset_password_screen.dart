import 'package:blinx_mobile/screens/authentication/reset_password/reset_controller/reset_controller.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/widgets/custom_button.dart';
import 'package:blinx_mobile/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/fonts.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 15,
            width: 15,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Text(
                  "Reset password",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontFamily: Fonts.interSemiBold,
                    color: ColorConstants.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Please reset your password to continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: Fonts.interRegular,
                    color: ColorConstants.greyColor,
                  ),
                ),
                const SizedBox(height: 37),

                CustomTextField(
                  labelText: "New Password",
                  hintText: "New password",
                  controller: controller.newPasswordController,
                  obscureText: true,
                  showEyeIcon: true,
                ),
                // Obx to reactive
                Obx(
                  () => controller.newPasswordError.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            controller.newPasswordError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: Fonts.interSemiBold,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  labelText: "Confirm Password",
                  hintText: "Confirm password",
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  showEyeIcon: true,
                ),
                //  Obx to reactive
                Obx(
                  () => controller.confirmPasswordError.value.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            controller.confirmPasswordError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily: Fonts.interSemiBold,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),

                Obx(
                  () => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: controller.authController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: "Reset Password",
                            borderRadius: 30,
                            color: ColorConstants.blueColor,
                            onPressed: () => controller.resetPassword(email),
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
