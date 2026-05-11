import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/my_submission/view/my_submission.dart';
import 'package:blinx_mobile/screens/profile/view/profile_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/comments_screen/view/comments_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/no_public_blinx_yet_screen/view/no_public_blinx_yet.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/custom_info_dialog.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/large_text.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../no_posts_yet_screens/widget/bluetooth_popupcard.dart';
import '../widget/action_box.dart';

class ConnectionErrorScreen extends StatelessWidget {
  ConnectionErrorScreen({super.key});

  final RxInt selectedIndex = (-1).obs;

  final RxList<Map<String, dynamic>> feedItems = <Map<String, dynamic>>[
    {
      "username": AppConstants.williamson,
      "time": AppConstants.fiftyMinAgo,
      "distance": AppConstants.halfMileAway,
      "verified": true,
      "description": AppConstants.fashionDescription,
      "hashtag": AppConstants.hashtagEnvironment,
      "avatar": "assets/images/williamson.png",
      "postImage": "assets/images/williamson.png",
      "likes": AppConstants.likesCount,
      "isLiked": false,
      "comments": AppConstants.commentsCount,
      "shares": AppConstants.sharesCount,
    },
    {
      "username": AppConstants.alanaUser,
      "time": AppConstants.fiftyMinAgo,
      "distance": AppConstants.halfMileAway,
      "verified": false,
      "description": AppConstants.fashionDescription,
      "hashtag": AppConstants.hashtagSafety,
      "avatar": "assets/images/alana.png",
      "postImage": "assets/images/alana.png",
      "likes": AppConstants.likesCount,
      "isLiked": false,
      "comments": AppConstants.commentsCount,
      "shares": null,
    },
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Image.asset(CommonUi.setPngIcon("blinx"), height: 34, width: 72),
        actions: [
          GestureDetector(
            onTap: () => Get.to(MySubmissionScreen()),
            child: Container(
              height: 36,
              width: 36,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: ColorConstants.lighterGreyColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  CommonUi.setPngIcon("ring"),
                  width: 18,
                  height: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.to(ProfileScreen()),
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorConstants.redColor, width: 2),
                ),
                child: Obx(() {
                  final image = AuthController.to.profileImage.value;
                  final ts = DateTime.now().millisecondsSinceEpoch;

                  return CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: image.isNotEmpty
                        ? NetworkImage("$image?v=$ts")
                        : null,
                    child: image.isEmpty
                        ? const Icon(Icons.person, size: 18, color: Colors.grey)
                        : null,
                  );
                }),
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          Column(
            children: [
              _bluetoothBanner(context),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: feedItems.length,
                    itemBuilder: (context, index) =>
                        _feedCard(context, feedItems[index], index),
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            top: 222,
            left: 21.5,
            child: CustomInfoDialog(
              iconPath: "assets/icons/connection.png",
              title: AppConstants.connectionError,
              subtitle: AppConstants.weCannotConnectToInternet,
              buttonText: AppConstants.retry,
              onButtonTap: () {
                Get.to(() => NoPublicBlinxYetScreen());
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1, color: const Color(0xFFEBEBEB)),

          Obx(
            () => CustomBottomBar(
              selectedIndex: selectedIndex.value,
              onTap: (index) {
                selectedIndex.value = index;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bluetoothBanner(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.3),
          builder: (context) => bluetoothPopupCard(),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC0C0C0), width: 1),
        ),
        child: Row(
          children: [
            Image.asset(ImageConstants.redFlag, width: 25, height: 16),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LargeText(text: AppConstants.thereMightBeBlinksNearYou),

                  SizedBox(height: 4),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SmallText(
                          text: AppConstants.turnOnBluetoothToView,
                        ),
                      ),

                      SizedBox(width: 2),

                      Icon(Icons.bluetooth, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            SvgPicture.asset(ImageConstants.crossIcon),
          ],
        ),
      ),
    );
  }

  Widget _feedCard(BuildContext context, Map<String, dynamic> item, int index) {
    final String? avatarPath = item["avatar"];
    final String? postImage = item["postImage"];
    final bool isVerified = item["verified"] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2A73EA),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: avatarPath != null
                      ? AssetImage(avatarPath)
                      : null,
                  child: avatarPath == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item["username"],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        if (isVerified)
                          Row(
                            children: [
                              Image.asset(
                                CommonUi.setPngIcon(AppConstants.verifiedIcon),
                                width: 14,
                                height: 14,
                              ),

                              const SizedBox(width: 4),

                              const Text(
                                AppConstants.verified,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        Text(
                          item["time"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),

                        const Text(
                          AppConstants.dotSeparator,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),

                        Text(
                          item["distance"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 68, right: 16),
          child: Text(
            item["description"],
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),

        const SizedBox(height: 4),

        Padding(
          padding: const EdgeInsets.only(left: 68, right: 16),
          child: Text(
            item["hashtag"],
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          height: 230,
          margin: const EdgeInsets.only(left: 68, right: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: postImage != null
              ? Image.asset(
                  postImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    );
                  },
                )
              : const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.only(left: 68, right: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                actionBox(
                  Icons.favorite,
                  item["likes"],
                  isActive: item["isLiked"] ?? false,
                  onTap: () {
                    feedItems[index]["isLiked"] =
                        !(feedItems[index]["isLiked"] ?? false);

                    feedItems.refresh();
                  },
                ),

                const SizedBox(width: 8),

                actionBox(
                  Icons.chat_bubble_outline,
                  item["comments"],
                  onTap: () {
                    Get.to(() => const CommentsScreen());
                  },
                ),

                if (item["shares"] != null) ...[
                  const SizedBox(width: 8),

                  actionBox(
                    Icons.reply,
                    item["shares"],
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.3),
                        barrierDismissible: true,
                        barrierLabel: AppConstants.share,
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, anim1, anim2) {
                          return NoPublicBlinxYetScreen();
                        },
                        transitionBuilder: (context, anim1, anim2, child) {
                          return SlideTransition(
                            position: Tween(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(anim1),
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),
      ],
    );
  }
}
