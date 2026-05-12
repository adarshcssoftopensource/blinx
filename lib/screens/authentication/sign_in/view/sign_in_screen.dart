import 'package:blinx_mobile/screens/authentication/sign_up/view/sign_up_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/blinx_logo.dart';
import 'package:blinx_mobile/widgets/custom_button.dart';
import 'package:blinx_mobile/widgets/custom_textfield.dart';
import 'package:blinx_mobile/widgets/segment_arc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../utils/screens/fonts.dart';
import '../../forgot_reset_password/view/forgot_password_screen.dart';
import '../controller/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: BlinxLogo()),
                const SizedBox(height: 53),
                const Text(
                  AppConstants.signIn,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontFamily: Fonts.interSemiBold,
                    color: ColorConstants.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppConstants.welcomeBack,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: Fonts.interRegular,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: ColorConstants.greyColor,
                  ),
                ),
                const SizedBox(height: 44),

                CustomTextField(
                  key: const Key('email_field'),
                  labelText: AppConstants.emailAddress,
                  hintText: AppConstants.enterEmail,
                  controller: controller.emailController,
                  obscureText: false,
                  showEyeIcon: false,
                ),
                Obx(
                  () => controller.emailError.value.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            controller.emailError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  key: const Key('password_field'),
                  labelText: AppConstants.password,
                  hintText: AppConstants.enterPassword,
                  controller: controller.passwordController,
                  obscureText: true,
                  showEyeIcon: true,
                ),
                Obx(
                  () => controller.passwordError.value.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4, left: 4),
                          child: Text(
                            controller.passwordError.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: const Text(
                      AppConstants.forgotPasswordLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: Fonts.interRegular,
                        height: 1.0,
                        letterSpacing: 0.0,
                        color: ColorConstants.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Obx(
                  () => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: controller.isSignInLoading.value
                        ? Container(
                            decoration: BoxDecoration(
                              color: ColorConstants.blueColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Center(
                              child: SegmentedArcLoader(
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          )
                        : Semantics(
                            identifier: 'signin_button',
                            label: 'signin_button',
                            child: CustomButton(
                              key: const Key('signin_button'),
                              text: AppConstants.signIn,
                              borderRadius: 100,
                              color: ColorConstants.blueColor,
                              isLoading: false,
                              onPressed: controller.validateAndLogin,
                            ),
                          ),
                    // : CustomButton(
                    //     key: const Key('signin_button'),
                    //     text: AppConstants.signIn,
                    //     borderRadius: 100,
                    //     color: ColorConstants.blueColor,
                    //     isLoading: false,
                    //     onPressed: controller.validateAndLogin,
                    //   ),
                  ),
                ),
                const SizedBox(height: 22),

                Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppConstants.or,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: Fonts.interSemiBold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),

                Obx(
                  () => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: controller.isGoogleLoading.value
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: SegmentedArcLoader(
                                color: Colors.blue,
                                size: 26,
                              ),
                            ),
                          )
                        : CustomButton(
                            key: const Key('google_signin_button'),
                            text: AppConstants.signInWithGoogle,
                            isGoogle: true,
                            borderRadius: 30,
                            onPressed: controller.signInWithGoogle,
                          ),
                  ),
                ),
                const SizedBox(height: 45),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppConstants.dontHaveAccount,
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        ),
                        child: const Text(
                          AppConstants.signUp,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
