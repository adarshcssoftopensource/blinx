import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:get/get.dart';

import '../../../business_logic/store_services.dart';
import '../model/marketplace_detail_model.dart';
import '../services/marketplace_detail_services.dart';

class MarketplaceDetailController extends GetxController {
  final MarketplaceDetailService service = MarketplaceDetailService();

  var isLoading = false.obs;
  var detail = Rxn<MarketplaceDetail>();

  Future<void> fetchDetail(String id) async {
    try {
      isLoading.value = true;
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) throw AppConstants.noAccessTokenFound;

      final result = await service.getDetail(id, token);

      if (result != null && result.id == id) {
        detail.value = result;
      } else {
        detail.value = null;
      }
    } catch (e) {
      detail.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
