import 'package:blinx_mobile/social_pulse_screen/block_users/controller/block_users_controller.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlockUsersController());

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        elevation: 0,

        centerTitle: true,

        title: const Text(
          AppConstants.blockedUsersTitle,

          style: TextStyle(
            color: Colors.black,

            fontSize: 14,

            fontWeight: FontWeight.w500,
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 17, color: Colors.black),

          onPressed: () {
            Get.back();

            Get.back();
          },
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2A73EA)),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  controller.errorMessage.value,

                  style: const TextStyle(color: Colors.red),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: controller.fetchBlockedUsers,

                  child: const Text(AppConstants.retry),
                ),
              ],
            ),
          );
        }

        if (controller.blockedUsers.isEmpty) {
          return const Center(child: Text(AppConstants.noBlockedUsers));
        }

        return ListView.builder(
          itemCount: controller.blockedUsers.length,

          itemBuilder: (context, index) {
            final user = controller.blockedUsers[index];

            return Column(
              children: [
                Obx(() {
                  final isUnblocking = controller.unblockingId.value == user.id;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.profileImage.isNotEmpty
                          ? NetworkImage(user.profileImage)
                          : null,

                      child: user.profileImage.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),

                    title: Text(user.name),

                    trailing: isUnblocking
                        ? const SizedBox(
                            width: 20,

                            height: 20,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,

                              color: Color(0xFF2A73EA),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () => controller.unblockUser(user.id),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A73EA),

                              elevation: 0,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,

                                vertical: 6,
                              ),

                              minimumSize: Size.zero,

                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),

                            child: const Text(
                              AppConstants.unblock,

                              style: TextStyle(
                                color: Colors.white,

                                fontSize: 12,

                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  );
                }),

                if (index != controller.blockedUsers.length - 1)
                  const Padding(
                    padding: EdgeInsets.only(left: 14, right: 14),

                    child: Divider(
                      height: 1,

                      thickness: 1.2,

                      color: Color(0xFFEEEEEE),
                    ),
                  ),
              ],
            );
          },
        );
      }),
    );
  }
}
