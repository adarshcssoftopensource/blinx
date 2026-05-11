import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_button.dart';
import '../controller/forgot_password_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                AppConstants.forgotPasswordTitle,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                AppConstants.forgotPasswordSubtitle,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF51585C),
                ),
              ),
              const SizedBox(height: 37),

              CustomTextField(
                labelText: AppConstants.emailAddress,
                hintText: AppConstants.enterEmail,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 6),

              Obx(
                () => controller.errorText.value.isNotEmpty
                    ? Text(
                        controller.errorText.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: Fonts.interRegular,
                        ),
                      )
                    : const SizedBox(height: 12),
              ),
              const SizedBox(height: 11),

              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: controller.authController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: AppConstants.next,
                          color: ColorConstants.blueColor,
                          borderRadius: 30,
                          onPressed: () => controller.submit(context),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
