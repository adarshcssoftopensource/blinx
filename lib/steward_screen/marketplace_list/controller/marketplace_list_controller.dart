import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:get/get.dart';

import '../model/marketplace_list_model.dart';
import '../services/marketplace_list_services.dart';

class MarketplaceListController extends GetxController {
  // Service to call marketplace dashboard API
  final MarketplaceDetail2Service service = MarketplaceDetail2Service();

  // Tracks API loading state
  final isLoading = false.obs;

  // Stores marketplace applications list
  final myApplications = <MarketplaceListModel>[].obs;

  // Current pagination page
  int page = 1;

  // Maximum records per page
  final int limit = 20;

  // Total records count from API
  final total = 0.obs;

  // Search query for filtering
  String searchQuery = '';

  //Selected main filter value
  String selectedMainFilter = AppConstants.allFilter;

  @override
  void onInit() {
    super.onInit();
  }

  // Holds full marketplace response
  Rx<MarketplaceListModel?> marketData = Rx<MarketplaceListModel?>(null);

  Future<void> getMarketPlaceApi() async {
    isLoading.value = true;
    try {
      final response = await service.getStewardDashboardService();

      if (response.success && response.data != null) {
        marketData.value = response.data;
      } else {
        marketData.value = null;
        Get.snackbar(
          AppConstants.failed,
          response.message ?? AppConstants.noDataAvailable,
        );
      }
    } catch (e, stace) {
      marketData.value = null;
      Get.snackbar(AppConstants.failed, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Safely converts dynamic value to int
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
