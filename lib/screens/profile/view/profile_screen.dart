import 'dart:io';

import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:blinx_mobile/screens/profile/controller/profile_screen_controller.dart';
import 'package:blinx_mobile/screens/profile/edit_profile/edit_profile.dart';
import 'package:blinx_mobile/screens/profile/plans/controller/plans_controller.dart';
import 'package:blinx_mobile/screens/profile/plans/plans_screen.dart';
import 'package:blinx_mobile/screens/profile/tune_your_world/tune_your_world.dart';
import 'package:blinx_mobile/screens/profile/widget/profile_section_card.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/saved_places/saved_places.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/shared_plan/shared_plans.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plans/upcoming_places.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/widgets/profile_shimmer.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/screens/string_constants.dart';
import '../../wallet/controller/wallet_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  ProfileController get _profileController =>
      Get.put(ProfileController(), permanent: false);

  WalletScreenController get _walletController =>
      Get.put(WalletScreenController(), permanent: false);

  final Rxn<File> _pickedImage = Rxn<File>();
  final RxInt _selectedTab = (-1).obs;

  static const List<String> _tabs = ["Posts", "Saved", "Plans"];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final ctx = Get.context!;

    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text(AppConstants.camera),
                  onTap: () async {
                    final image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      _pickedImage.value = File(image.path);
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(AppConstants.gallery),
                  onTap: () async {
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      _pickedImage.value = File(image.path);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Controllers ek baar lelo — getters baar baar na chalein
    final profileController = _profileController;
    final walletController = _walletController;

    // initState ka kaam — pehli baar build pe fetch karo
    if (profileController.profileData.value == null) {
      profileController.getProfileApi();
    }
    walletController.loadWalletLedger();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final editBtnWidth = screenWidth * 0.16;
    final editBtnHeight = screenHeight * 0.038;

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
          onPressed: () async {
            final updatedImage = await StoreServices.getProfileImage() ?? '';
            AuthController.to.profileImage.value = updatedImage;
            await profileController.getProfileApi();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          AppConstants.profile,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: screenWidth * 0.04),
            child: SizedBox(
              width: editBtnWidth,
              height: editBtnHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2A73EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                  await profileController.getProfileApi();
                },
                child: const Center(
                  child: Text(
                    AppConstants.edit,
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
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value ||
            walletController.isLoading.value) {
          return const ProfileShimmer();
        }

        final userName =
            profileController.profileData.value?.data.user.name
                .toString()
                .capitalizeFirst ??
            '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.015),

                  // Profile avatar — sirf image pick hone pe rebuild ho
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Obx(() {
                            final picked = _pickedImage.value;
                            final networkImage = profileController
                                .profileData
                                .value
                                ?.data
                                .user
                                .image;

                            return CircleAvatar(
                              radius: screenWidth * 0.145,
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: picked != null
                                    ? Image.file(
                                        picked,
                                        width: screenWidth * 0.29,
                                        height: screenWidth * 0.29,
                                        fit: BoxFit.cover,
                                      )
                                    : (networkImage != null &&
                                          networkImage.isNotEmpty)
                                    ? Image.network(
                                        "$networkImage?v=${DateTime.now().millisecondsSinceEpoch}",
                                        width: screenWidth * 0.29,
                                        height: screenWidth * 0.35,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return const Center(
                                                child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                          Colors.blue,
                                                        ),
                                                  ),
                                                ),
                                              );
                                            },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Center(
                                                child: Text(
                                                  profileController
                                                          .profileData
                                                          .value
                                                          ?.data
                                                          .user
                                                          .name
                                                          ?.substring(0, 1)
                                                          .toUpperCase() ??
                                                      "",
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            },
                                      )
                                    : Center(
                                        child: Text(
                                          profileController
                                                  .profileData
                                                  .value
                                                  ?.data
                                                  .user
                                                  .name
                                                  ?.substring(0, 1)
                                                  .toUpperCase() ??
                                              "",
                                          style: const TextStyle(
                                            fontSize: 28,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          AppConstants.member,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.022),

                  const Text(
                    AppConstants.emailAddress,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Text(
                    profileController.profileData.value?.data.user.email ?? '',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  SizedBox(height: screenHeight * 0.027),
                  Container(height: 1, color: Colors.black12),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),

            const SizedBox(height: 0),

            // ── Tabs — Obx wrap
            Obx(() {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = _selectedTab.value == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          _selectedTab.value = index;

                          if (index == 0) {
                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );
                            Get.back();
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedPlaces(),
                              ),
                            );
                          } else if (index == 2) {
                            Get.put(PlansController(), tag: AppConstants.plans);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PlansScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: index != _tabs.length - 1 ? 6 : 0,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorConstants.blueColor
                                : Colors.white,
                            border: Border.all(color: ColorConstants.white2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: SmallText(
                              text: _tabs[index],
                              fontSize: 12,
                              color: isSelected
                                  ? ColorConstants.white
                                  : ColorConstants.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),

            const SizedBox(height: 16),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 1,
                  width: screenWidth * 0.95,
                  color: Colors.black12,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ── Section cards ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.045),
                children: [
                  ProfileSectionCard(
                    title: AppConstants.savedPlaces,
                    onTap: () => Get.to(() => const SavedPlaces()),
                  ),
                  ProfileSectionCard(
                    title: AppConstants.upcomingPlans,
                    onTap: () => Get.to(() => const UpcomingPlaces()),
                  ),
                  ProfileSectionCard(
                    title: AppConstants.sharedPlans,
                    onTap: () => Get.to(() => const SharedPlans()),
                  ),
                  ProfileSectionCard(
                    title: AppConstants.interests,
                    onTap: () => Get.to(() => const TuneYourWorld()),
                  ),
                  ProfileSectionCard(
                    title: AppConstants.communityStanding,
                    onTap: () {},
                  ),
                  ProfileSectionCard(
                    title: AppConstants.recentActivity,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ── Logout button ──
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.045,
                10,
                screenWidth * 0.045,
                24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF2A73EA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    await StoreServices.clearAccessToken();
                    await StoreServices.clearStewardStatus();
                    Get.delete<ProfileController>(force: true);
                    Get.delete<WalletScreenController>(force: true);
                    Get.snackbar(
                      AppConstants.success,
                      AppConstants.loggedOutSuccessfully,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                    );
                    Get.offAll(() => SignInScreen());
                  },
                  child: const Text(
                    AppConstants.logout,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
