import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/custom_button.dart';
import 'package:blinx_mobile/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          AppConstants.changePassword,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                labelText: AppConstants.currentPassword,
                hintText: AppConstants.enterOldPassword,
                controller: currentPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),

              CustomTextField(
                labelText: AppConstants.newPassword,
                hintText: AppConstants.enterNewPassword,
                controller: newPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 18),

              CustomTextField(
                labelText: AppConstants.confirmPassword,
                hintText: AppConstants.enterConfirmPassword,
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),

              Center(
                child: CustomButton(
                  text: AppConstants.updatePassword,
                  onPressed: () {},
                  borderRadius: 30,
                  width: 200,
                  height: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
