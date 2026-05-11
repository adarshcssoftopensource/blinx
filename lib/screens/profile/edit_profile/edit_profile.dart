import 'dart:io';

import 'package:blinx_mobile/screens/profile/controller/profile_screen_controller.dart';
import 'package:blinx_mobile/screens/profile/view/profile_screen.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/screens/string_constants.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  ProfileController get _profileController => Get.put(ProfileController());

  final Rxn<File> _profileImage = Rxn<File>();

  Future<void> _saveProfile(BuildContext context) async {
    final profileController = _profileController;

    final Map<String, dynamic> data = {
      "name": profileController.nameController.text.trim(),
    };

    if (_profileImage.value != null) {
      data["profileImage"] = await dio.MultipartFile.fromFile(
        _profileImage.value!.path,
        filename: _profileImage.value!.path.split('/').last,
      );
    }

    final formData = dio.FormData.fromMap(data);
    profileController.profileUpdateApi(formData);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen()),
      (route) => route.isFirst,
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(AppConstants.camera),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (picked != null) {
                    _profileImage.value = File(picked.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text(AppConstants.gallery),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    _profileImage.value = File(picked.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Builds a styled text field with optional read-only and grey fill support
  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    bool? readOnly,
    bool isGrey = false,
  }) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
          ),
          filled: true,
          fillColor: isGrey ? const Color(0xFFE5E7EB) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD3D3D3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD3D3D3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Color(0xFFD3D3D3)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = _profileController;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonWidth = screenWidth * 0.16;
    final buttonHeight = screenHeight * 0.038;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            CommonUi.setPngIcon("left_vector"),
            height: 14,
            width: 14,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppConstants.editProfile,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.04),
            child: SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: TextButton(
                onPressed: () => _saveProfile(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2A73EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const SizedBox.expand(
                  child: Center(
                    child: Text(
                      AppConstants.save,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = profileController.profileData.value?.data;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickImage(context),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final pickedFile = _profileImage.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: pickedFile != null
                            ? FileImage(pickedFile)
                            : profile?.user.image != null
                            ? NetworkImage(profile?.user.image ?? '')
                            : null,
                        backgroundColor: Colors.grey.shade300,
                        child: profile?.user.image == null && pickedFile == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      );
                    }),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 6),
              _buildTextField(profileController.nameController, ''),
              const SizedBox(height: 26),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppConstants.emailAddress,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 6),
              _buildTextField(
                profileController.emailController,
                "",
                readOnly: true,
                isGrey: true,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
