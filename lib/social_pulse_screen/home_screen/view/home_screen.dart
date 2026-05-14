import 'package:blinx_mobile/screens/authentication/controller/auth_controller.dart';
import 'package:blinx_mobile/screens/profile/controller/profile_screen_controller.dart';
import 'package:blinx_mobile/screens/profile/view/profile_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/bluetooth_screen/view/bluetooth_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/comments_screen/view/comments_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/create_post_private_screen/view/create_post_private_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/controller/home_screen_controller.dart';
import 'package:blinx_mobile/social_pulse_screen/home_screen/model/home_screen_model.dart';
import 'package:blinx_mobile/social_pulse_screen/post_detail_screen/view/post_detail_screen.dart';
import 'package:blinx_mobile/social_pulse_screen/share_screen/view/share_screen.dart';
import 'package:blinx_mobile/utils/screens/color_constants.dart';
import 'package:blinx_mobile/utils/screens/custom_info_dialog.dart';
import 'package:blinx_mobile/utils/screens/image_constants.dart';
import 'package:blinx_mobile/widgets/bottom_navbar_widget.dart';
import 'package:blinx_mobile/widgets/home_shimmer.dart';
import 'package:blinx_mobile/widgets/shimmer_loader.dart';
import 'package:blinx_mobile/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/screens/string_constants.dart';
import '../../../widgets/large_text.dart' show LargeText;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeScreenController());

    ever(controller.blinks, (_) {
      if (!controller.isLoading.value &&
          !controller.hasError.value &&
          controller.blinks.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNoPostDialogIfFirstTime(context);
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final profileController = Get.put(ProfileController());
        await profileController.getProfileApi();
      } catch (e) {}
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.white,
          centerTitle: false,
          title: Image.asset(
            CommonUi.setPngIcon("blinx"),
            height: 34,
            width: 72,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                // onTap: () => Get.to(() => ProfileScreen()),
                // child: Container(
                //   height: 38,
                //   width: 38,
                key: const Key('home_profile_avatar'),
                onTap: () => Get.to(() => ProfileScreen()),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstants.redColor,
                      width: 2,
                    ),
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
                          ? const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.grey,
                            )
                          : null,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),

        body: Obx(() {
          return Stack(
            children: [
              Column(
                children: [
                  _bluetoothBanner(context),
                  if (controller.isLoading.value && controller.blinks.isEmpty)
                    const Expanded(child: HomeShimmer())
                  else if (controller.hasError.value ||
                      controller.blinks.isEmpty)
                    const Expanded(child: SizedBox.shrink())
                  else
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.refreshFeed(),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          itemCount: controller.blinks.length,
                          itemBuilder: (context, index) {
                            if (index == controller.blinks.length - 1) {
                              controller.loadMore();
                            }
                            return _feedCard(
                              context,
                              controller.blinks[index],
                              controller,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),

              if (!controller.isLoading.value && controller.hasError.value)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: CustomInfoDialog(
                        iconPath: "assets/icons/connection.png",
                        title: AppConstants.connectionError,
                        subtitle: AppConstants.connectionErrorHandling,
                        buttonText: AppConstants.retry,
                        onButtonTap: () {
                          controller.refreshFeed();
                        },
                      ),
                    ),
                  ),
                ),

              if (!controller.isLoading.value &&
                  !controller.hasError.value &&
                  controller.blinks.isEmpty)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: CustomInfoDialog(
                        iconPath: "assets/icons/no_posts.png",
                        title: AppConstants.noPostsYet,
                        subtitle: AppConstants.yourFirstBlinxWithPhoto,
                        buttonText: AppConstants.postTheFirstBlinx,
                        onButtonTap: () =>
                            Get.to(() => const CreatePostPrivateScreen()),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),

        floatingActionButton: GestureDetector(
          // onTap: () => Get.to(() => const CreatePostPrivateScreen()),
          // child: Container(
          //   width: 56,
          //   height: 56,
          key: const Key('home_fab_create_post'),
          onTap: () => Get.to(() => const CreatePostPrivateScreen()),
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFD8DBDF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFF0E1A2B), size: 42),
          ),
        ),

        bottomNavigationBar: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 1, color: const Color(0xFFEBEBEB)),
              CustomBottomBar(
                selectedIndex: controller.selectedIndex.value,
                onTap: (index) => controller.selectedIndex.value = index,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNoPostDialogIfFirstTime(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyShown = prefs.getBool('no_post_dialog_shown') ?? false;
    if (!alreadyShown) {
      await prefs.setBool('no_post_dialog_shown', true);
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: CustomInfoDialog(
            iconPath: "assets/icons/no_posts.png",
            title: AppConstants.noPostsYet,
            subtitle: AppConstants.yourFirstBlinx,
            buttonText: AppConstants.postTheFirstBlinx,
            onButtonTap: () {
              Get.back();
              Get.to(() => const CreatePostPrivateScreen());
            },
          ),
        ),
      );
    }
  }

  Widget _bluetoothBanner(BuildContext context) {
    return GestureDetector(
      // onTap: () => showDialog(
      //   context: context,
      //   barrierColor: Colors.black.withOpacity(0.3),
      //   builder: (context) => BluetoothPopup(),
      key: const Key('home_bluetooth_banner'),
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (context) => BluetoothPopup(),
      ),
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
                  LargeText(text: AppConstants.nearBlinks),
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
                      Icon(Icons.bluetooth, size: 14),
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

  Widget _feedCard(
    BuildContext context,
    HomeScreenModel item,
    HomeScreenController controller,
  ) {
    return Obx(() {
      final index = controller.blinks.indexWhere((b) => b.id == item.id);
      final blink = index != -1 ? controller.blinks[index] : item;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.to(() => PostDetailScreen(blinkId: blink.id)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 16, 1),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF2A73EA),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: blink.author.profileImage.isNotEmpty
                          ? Image.network(
                              blink.author.profileImage,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const ShimmerLoader(
                                  height: 44,
                                  width: 44,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22),
                                  ),
                                );
                              },
                            )
                          : const Icon(Icons.person, size: 20),
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
                              blink.author.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (blink.author.isVerified)
                              Row(
                                children: [
                                  Image.asset(
                                    CommonUi.setPngIcon("verified"),
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
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Text(
                              _timeAgo(blink.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF7A7A7A),
                              ),
                            ),
                            if (blink.locationName.isNotEmpty) ...[
                              const Text(
                                " · ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7A7A7A),
                                ),
                              ),
                              Text(
                                blink.locationName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF7A7A7A),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 1),

          Padding(
            padding: const EdgeInsets.only(left: 70, right: 16),
            child: Text(
              blink.content,
              style: const TextStyle(fontSize: 13, height: 0),
            ),
          ),

          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: Text(
              "#${blink.topic.name}",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 4),

          if (blink.imageUrl != null && blink.imageUrl!.isNotEmpty)
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.9),
                builder: (context) => Stack(
                  children: [
                    Center(
                      child: InteractiveViewer(
                        child: Image.network(
                          blink.imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Image.asset(
                          CommonUi.setPngIcon("left_vector"),
                          height: 15,
                          width: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 230,
                margin: const EdgeInsets.only(left: 68, right: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  blink.imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const ShimmerLoader(
                      height: 230,
                      width: double.infinity,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.only(left: 68, right: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // _actionBox(
                  //   Icons.favorite,
                  //   blink.likeCount.toString(),
                  //   isActive: blink.isLikedByMe,
                  //   isLikeButton: true,
                  //   onTap: () => controller.toggleLike(blink.id),
                  // ),
                  _actionBox(
                    Icons.favorite,
                    blink.likeCount.toString(),
                    key: Key('like_btn_${blink.id}'),
                    isActive: blink.isLikedByMe,
                    isLikeButton: true,
                    onTap: () => controller.toggleLike(blink.id),
                  ),
                  const SizedBox(width: 8),
                  // _actionBox(
                  //   Icons.chat_bubble_outline,
                  //   blink.commentCount.toString(),
                  //   onTap: () => Get.to(
                  _actionBox(
                    Icons.chat_bubble_outline,
                    blink.commentCount.toString(),
                    key: Key('comment_btn_${blink.id}'),
                    onTap: () => Get.to(
                      () => const CommentsScreen(),
                      arguments: {
                        'blinkId': blink.id,
                        'isLiked': blink.isLikedByMe,
                        'likeCount': blink.likeCount,
                        'content': blink.content,
                        'topicName': blink.topic.name,
                        'createdAt': blink.createdAt,
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // _actionBox(
                  //   Icons.reply,
                  //   blink.shareCount.toString(),
                  //   onTap: () => showModalBottomSheet(
                  _actionBox(
                    Icons.reply,
                    blink.shareCount.toString(),
                    key: Key('share_btn_${blink.id}'),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (context) => ShareScreen(blinkId: blink.id),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            height: 1,
            color: const Color(0xFFEBEBEB),
          ),
        ],
      );
    });
  }

  // Widget _actionBox(
  //   IconData icon,
  //   String count, {
  //   bool isActive = false,
  Widget _actionBox(
    IconData icon,
    String count, {
    Key? key,
    bool isActive = false,
    VoidCallback? onTap,
    String? imagePath,
    bool isLikeButton = false,
    bool flipIcon = false,
  }) {
    // return GestureDetector(
    //   onTap: onTap,
    //   child: Container(
    //     height: 31,
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(15.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            imagePath != null
                ? Image.asset(imagePath, width: 14, height: 14)
                : Transform(
                    alignment: Alignment.center,
                    transform: flipIcon
                        ? Matrix4.rotationY(3.14159)
                        : Matrix4.identity(),
                    child: Icon(
                      isLikeButton
                          ? (isActive ? Icons.favorite : Icons.favorite_border)
                          : icon,
                      size: 14,
                      color: isActive ? Colors.red : Colors.black,
                    ),
                  ),
            const SizedBox(width: 4),
            Text(
              count,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return AppConstants.justNow;
      if (diff.inMinutes < 60)
        return "${diff.inMinutes}${AppConstants.minuteAgo}";
      if (diff.inHours < 24) return "${diff.inHours}${AppConstants.hourAgo}";
      if (diff.inDays < 7) return "${diff.inDays}${AppConstants.dayAgo}";
      return "${(diff.inDays / 7).floor()}${AppConstants.weekAgo}";
    } catch (e) {
      return AppConstants.empty;
    }
  }
}
