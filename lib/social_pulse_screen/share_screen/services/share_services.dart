import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:dio/dio.dart';

class ShareServices {
  final BaseApiService _api = BaseApiService();

  //record the share
  Future<ApiResponse> shareBlink({required String blinkId}) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      final response = await _api.post(
        'mobile/social/blinks/$blinkId/share',
        null,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: "Shared successfully",
        );
      }
      return ApiResponse(success: false, message: "Share failed");
    } catch (e) {
      return handleDioError(e);
    }
  }

  // fetch pre-built share links for each platform
  Future<ApiResponse> getShareLink({required String blinkId}) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      final response = await _api.get(
        'mobile/social/blinks/$blinkId/share-link',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: "Share link fetched successfully",
        );
      }
      return ApiResponse(success: false, message: "Failed to fetch share link");
    } on DioException catch (e) {
      // Parse backend error message
      final serverMessage = e.response?.data?['message'];
      if (serverMessage != null && serverMessage is String) {
        return ApiResponse(success: false, message: serverMessage);
      }
      return handleDioError(e);
    } catch (e) {
      return handleDioError(e);
    }
  }
}
