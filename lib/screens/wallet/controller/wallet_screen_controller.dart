import 'package:get/get.dart';

import '../../../business_logic/store_services.dart';
import '../model/wallet_screen_model.dart';
import '../services/wallet_screen_services.dart';

class WalletScreenController extends GetxController {
  // Reactive state variables for loading, credits, grants, scores and activity
  var isLoading = false.obs;
  var walletCredits = 0.0.obs;
  var microGrantsBalance = RxnDouble();
  var reputationScores = <ReputationScore>[].obs;
  var recentActivity = <Map<String, dynamic>>[].obs;

  final WalletScreenService _service = WalletScreenService();

  Future<void> loadWalletLedger() async {
    isLoading.value = true;

    // Fetches stored access token and aborts if not found
    final token = await StoreServices.getAccessToken();
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      return;
    }

    // Calls the API services to fetch wallet ledger data using the token
    final response = await _service.fetchWalletLedger(token: token);

    if (response.status) {
      // Maps API response fields into their respective reactive observables
      walletCredits.value = response.wallet.availableCredits;

      microGrantsBalance.value = response.wallet.microGrantsBalance;

      reputationScores.value = response.reputationScores;

      // Casts the raw activity list to a typed list of maps for use  in UI
      recentActivity.value = (response.recentActivity as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
    }
    isLoading.value = false;
  }
}
