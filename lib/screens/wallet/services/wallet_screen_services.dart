import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:dio/dio.dart';

import '../model/wallet_screen_model.dart';

class WalletScreenService {
  final Dio _dio = Dio();
  final BaseApiService baseApiService = BaseApiService();
  Future<WalletLedgerResponse> fetchWalletLedger({
    required String token,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Makes a GET request to the wallet ledger endpoint with pagination and auth header
      final response = await _dio.get(
        '${baseApiService.baseUrl}mobile/wallet/ledger',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      // Parses the raw API response into a typed WalletLedgerResponse model
      return WalletLedgerResponse.fromJson(response.data);
    } catch (e) {
      // Returns a default empty response on failure to prevent app crash
      return WalletLedgerResponse(
        status: false,
        wallet: Wallet(availableCredits: 0),
        reputationScores: [],
        recentActivity: [],
        currentPage: 1,
        totalPages: 0,
        totalCount: 0,
      );
    }
  }
}
