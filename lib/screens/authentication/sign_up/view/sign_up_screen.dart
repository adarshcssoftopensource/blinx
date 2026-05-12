import 'package:blinx_mobile/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:blinx_mobile/screens/terms/view/terms_conditions.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/fonts.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/custom_button.dart';
import 'package:blinx_mobile/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/segment_arc_widget.dart';
import '../controller/sign_up_controller.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageWidget(controller, context),
                const SizedBox(height: 40),
                _buildTextField(
                  AppConstants.fullName,
                  AppConstants.enterFullName,
                  controller.nameController,
                  controller.nameError,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  AppConstants.emailAddress,
                  AppConstants.enterEmail,
                  controller.emailController,
                  controller.emailError,
                ),
                const SizedBox(height: 14),
                _buildTextField(
                  AppConstants.password,
                  AppConstants.enterPassword,
                  controller.passwordController,
                  controller.passwordError,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                _termsText(context),
                const SizedBox(height: 40),
                _signUpButton(controller, context),
                const SizedBox(height: 20),
                _orDivider(),
                const SizedBox(height: 20),
                _googleButton(controller),
                const SizedBox(height: 30),
                _signInText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController textController,
    RxString error, {
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          labelText: label,
          hintText: hint,
          controller: textController,
          obscureText: obscureText,
          showEyeIcon: obscureText,
        ),
        Obx(
          () => error.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(
                    error.value,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _termsText(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            height: 1.5,
          ),
          children: [
            const TextSpan(
              text: AppConstants.agreeToTerms,
              style: TextStyle(
                fontSize: 12,
                fontFamily: Fonts.interRegular,
                fontWeight: FontWeight.w400,
                color: ColorConstants.black,
              ),
            ),
            TextSpan(
              text: AppConstants.termsOfUse,
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsConditions()),
                ),
            ),
            const TextSpan(text: AppConstants.and),
            TextSpan(
              text: AppConstants.privacyPolicy,
              style: const TextStyle(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  Widget _signUpButton(SignUpController controller, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(
        () => controller.isSignUpLoading.value
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A73EA),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: SegmentedArcLoader(color: Colors.white, size: 26),
                ),
              )
            : Semantics(
                identifier: 'signup_button',
                label: 'signup_button',
                child: CustomButton(
                  key: const Key('signup_button'),
                  text: AppConstants.signUp,
                  borderRadius: 30,
                  color: const Color(0xFF2A73EA),
                  isLoading: false,
                  onPressed: () => controller.signUp(context),
                ),
              ),
      ),
    );
  }
  // Widget _signUpButton(SignUpController controller, BuildContext context) {
  //   return SizedBox(
  //     width: double.infinity,
  //     height: 50,
  //     child: Obx(
  //       () => controller.isSignUpLoading.value
  //           ? Container(
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF2A73EA),
  //                 borderRadius: BorderRadius.circular(30),
  //               ),
  //               child: const Center(
  //                 child: SegmentedArcLoader(color: Colors.white, size: 26),
  //               ),
  //             )
  //           : CustomButton(
  //               key: const Key('signup_button'),
  //               text: AppConstants.signUp,
  //               borderRadius: 30,
  //               color: const Color(0xFF2A73EA),
  //               isLoading: false,
  //               onPressed: () => controller.signUp(context),
  //             ),
  //     ),
  //   );
  // }

  Widget _googleButton(SignUpController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(
        () => controller.isGoogleLoading.value
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: SegmentedArcLoader(color: Colors.blue, size: 26),
                ),
              )
            : Semantics(
                identifier: 'google_signup_button',
                label: 'google_signup_button',
                child: CustomButton(
                  key: const Key('google_signup_button'),
                  text: AppConstants.signUpWithGoogle,
                  isGoogle: true,
                  borderRadius: 30,
                  isLoading: false,
                  onPressed: controller.signUpWithGoogle,
                ),
              ),
      ),
    );
  }

  Widget _orDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            AppConstants.or,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }

  Widget _signInText(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppConstants.alreadyHaveAccount,
            style: TextStyle(color: Colors.black54),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignInScreen()),
            ),
            child: const Text(
              AppConstants.signIn,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageWidget(SignUpController controller, BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.4), width: 2),
            ),
            child: ClipOval(
              // Obx to reactively image update
              child: Obx(
                () => controller.imageFile.value != null
                    ? Image.file(controller.imageFile.value!, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 5,
            child: GestureDetector(
              onTap: () => _showImageSourceDialog(controller, context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE94E45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(
    SignUpController controller,
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(AppConstants.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(AppConstants.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
