import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockUserController extends GetxController {
  final RxList<Map<String, dynamic>> blockedUsers = [
    {'avatar': 'assets/images/men1.jpg', 'name': 'Taylor'},
    {'avatar': 'assets/images/women1.jpg', 'name': 'Javier'},
    {'avatar': 'assets/images/men2.jpg', 'name': 'Williamson'},
    {'avatar': 'assets/images/women2.jpg', 'name': 'Alana'},
    {'avatar': 'assets/images/men3.jpg', 'name': 'Galen'},
    {'avatar': 'assets/images/women1.jpg', 'name': 'Nacho'},
    {'avatar': 'assets/images/men1.jpg', 'name': 'John'},
    {'avatar': 'assets/images/women2.jpg', 'name': 'Joey'},
    {'avatar': 'assets/images/men2.jpg', 'name': 'Galen'},
    {'avatar': 'assets/images/women1.jpg', 'name': 'Henrik'},
    {'avatar': 'assets/images/women2.jpg', 'name': 'Bean'},
  ].obs;

  void unblockUser(int index) {
    blockedUsers.removeAt(index);
  }
}

class BlockUser extends StatelessWidget {
  const BlockUser({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlockUserController());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Blocked Users",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: controller.blockedUsers.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 20,
              ),
            ),
            itemBuilder: (context, index) {
              final user = controller.blockedUsers[index];
              return Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(user['avatar']),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          user['name'],
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => controller.unblockUser(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Unblock",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
