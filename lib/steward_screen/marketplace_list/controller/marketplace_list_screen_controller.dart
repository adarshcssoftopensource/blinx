import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:get/get.dart';

import '../controller/marketplace_list_controller.dart';

class MarketplaceListScreenController extends GetxController {
  final MarketplaceListController marketplaceListController =
      MarketplaceListController();

  final RxString searchQuery = ''.obs;
  final RxInt selectedIndex = 1.obs;
  final RxBool isSteward = false.obs;

  @override
  void onInit() {
    super.onInit();
    marketplaceListController.getMarketPlaceApi();
    StoreServices.getStewardStatus().then((value) {
      isSteward.value = value;
    });
  }
}
