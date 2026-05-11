import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../tune_your_world_model.dart';
import '../tune_your_world_services.dart';

class TuneYourWorldController extends GetxController {
  final TuneYourWorldServices _services = TuneYourWorldServices();

  var interestsList = <InterestModel>[].obs;
  var selectedIds = <String>{}.obs;
  var isLoading = false.obs;

  Future<void> saveInterests() async {
    final newlySelected = interestsList
        .where((i) => !i.isAlreadySaved && selectedIds.contains(i.id))
        .toList();

    if (newlySelected.isEmpty) {
      Get.snackbar(
        "Oops!",
        "Please select at least one new interest",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final response = await _services.saveInterests(
        token: token,
        interestIds: newlySelected.map((i) => i.id).toList(),
      );

      final data = response['data'];

      if (data != null && data['status'] == true) {
        Get.snackbar(
          "Success!",
          "Interests saved successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        await Future.delayed(const Duration(milliseconds: 800));
        Get.offAll(() => ProfileScreen());
      } else {}
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchInterests() async {
    try {
      isLoading.value = true;
      selectedIds.clear();

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final response = await _services.getInterests(token: token);
      final data = response['data'];

      if (data != null && data['status'] == true) {
        final List interests = data['interests'] ?? [];
        interestsList.value = interests
            .map((e) => InterestModel.fromJson(e))
            .toList();

        selectedIds.value = interestsList
            .where((i) => i.isAlreadySaved)
            .map((i) => i.id)
            .toSet();
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void toggleInterest(String id) {
    final interest = interestsList.firstWhereOrNull((i) => i.id == id);
    if (interest != null && interest.isAlreadySaved) return;

    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }
}
