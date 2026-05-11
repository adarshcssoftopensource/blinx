import 'package:blinx_mobile/utils/screens/string_constants.dart';

import '../../../business_logic/api_response.dart';
import '../../../business_logic/base_api_service.dart';
import '../../../business_logic/store_services.dart';
import '../model/marketplace_detail_model.dart';

class MarketplaceDetailServices {
  final BaseApiService baseApiService = BaseApiService();

  // Get Application Detail
  Future<ApiResponse<ApplicationDetailResponse?>>
  getMarketPlaceApplicationDetailService({String? id}) async {
    var authToken = await StoreServices.getAccessToken();
    try {
      var response = await baseApiService.get(
        "mobile/marketplace/dashboard-items/$id/detail",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: AppConstants.applicationDetailFetched,
          data: ApplicationDetailResponse.fromJson(response.data),
        );
      } else {
        return ApiResponse(
          success: false,
          message: AppConstants.somethingWentWrong,
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  // Approve Application
  Future<ApiResponse<String?>> acceptApplicationService(
    Map<String, dynamic> postData, {
    required String id,
  }) async {
    final authToken = await StoreServices.getAccessToken();

    try {
      final response = await baseApiService.post(
        "mobile/marketplace/dashboard-items/$id/approve",
        postData,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message =
            response.data?['data']?['message'] ??
            AppConstants.applicationApproved;

        return ApiResponse<String?>(
          success: true,
          message: message,
          data: message,
        );
      } else {
        return ApiResponse<String?>(
          success: false,
          message: AppConstants.somethingWentWrong,
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  // Reject Application
  Future<ApiResponse<String?>> rejectApplicationService(
    Map<dynamic, dynamic> postData, {
    String? id,
  }) async {
    var authToken = await StoreServices.getAccessToken();
    try {
      var response = await baseApiService.post(
        "mobile/marketplace/dashboard-items/$id/reject",
        postData,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message =
            response.data?['data']?['message'] ??
            AppConstants.applicationRejected;
        return ApiResponse<String?>(
          success: true,
          message: message,
          data: message,
        );
      } else {
        return ApiResponse(
          success: false,
          message: AppConstants.somethingWentWrong,
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }
}
