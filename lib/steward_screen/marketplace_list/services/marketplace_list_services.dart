import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';

import '../model/marketplace_list_model.dart';

class MarketplaceDetail2Service {
  // Base API services instance for network calls
  final BaseApiService baseApiService = BaseApiService();

  // Fetches steward dashboard data from API
  Future<ApiResponse<MarketplaceListModel?>>
  getStewardDashboardService() async {
    // Retrieve stored access token

    var authToken = await StoreServices.getAccessToken();
    try {
      // Perform GET request for steward dashboard
      var response = await baseApiService.get(
        "mobile/marketplace/steward-dashboard?type=all",
        headers: {"Authorization": "Bearer $authToken"},
      );

      // Check for successful response status
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: AppConstants.fetchSuccessfully,
          data: MarketplaceListModel.fromJson(response.data),
        );
      } else {
        return ApiResponse(
          success: false,
          message: AppConstants.somethingWentWrong,
        );
      }
    } catch (e) {
      // Return failure response
      return handleDioError(e);
    }
  }
}
