import 'package:blinx_mobile/utils/screens/snackbar_helper.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:get/get.dart';

import '../../../business_logic/store_services.dart';
import '../model/marketplace_model.dart';
import '../services/marketplace_services.dart';

class MarketplaceController extends GetxController {
  final MarketplaceServices services = MarketplaceServices();

  final isLoading = false.obs;
  final myApplications = <MarketplaceApplication>[].obs;

  int page = 1;
  final int limit = 20;
  final total = 0.obs;

  final selectedMainFilter = AppConstants.allFilter.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApplications();
  }

  Future<void> fetchMyApplications({int? pageNumber}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        throw AppConstants.noAccessTokenFound;
      }

      final currentPage = pageNumber ?? page;

      final response = await services.getMarketplace(token, currentPage, limit);

      final data = response.data;

      if (data != null && data['status'] == true) {
        final List tasks = data['tasks'] ?? [];

        final parsedItems = tasks
            .map((e) => MarketplaceApplication.fromJson(e))
            .toList();

        if (currentPage == 1) {
          myApplications.value = parsedItems;
        } else {
          myApplications.addAll(parsedItems);
        }

        total.value = _parseInt(data['totalCount']);
        page = currentPage;
      } else {
        AppSnackbar.show(
          title: AppConstants.failed,
          message: AppConstants.failedToFetchMarketplace,
          isSuccess: false,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: AppConstants.failed,
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<MarketplaceApplication> get filteredApplications {
    if (selectedMainFilter.value == AppConstants.allFilter) {
      return myApplications;
    }

    return myApplications
        .where(
          (item) =>
              item.status.toLowerCase() ==
              selectedMainFilter.value.toLowerCase(),
        )
        .toList();
  }

  void loadNextPage() {
    if (!isLoading.value && (page * limit) < total.value) {
      fetchMyApplications(pageNumber: page + 1);
    }
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
