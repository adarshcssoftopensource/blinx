import 'package:blinx_mobile/screens/marketplace/controller/marketplace_controller.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketplaceScreenController extends GetxController {
  // Tracks current page index for page indicator dots
  final RxInt currentPage = 0.obs;

  // Tracks selected bottom nav index (-1 = none selected by default)
  final RxInt selectedIndex = (-1).obs;

  // Active filter chip label
  String activeFilter = AppConstants.allFilter;

  // Live search query — filters marketplace list as user types
  final RxString searchQuery = "".obs;

  // GetX controller managing marketplace data fetch and pagination
  late final MarketplaceController marketplaceController;

  @override
  void onInit() {
    super.onInit();
    // Register MarketplaceController and trigger initial data load
    marketplaceController = Get.put(MarketplaceController());
    debugPrint("MarketplaceScreen onInit called");
  }

  void updateFilter(String filter, BuildContext context) {
    activeFilter = filter;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${AppConstants.filterApplied}$filter")),
    );
  }
}
