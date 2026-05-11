import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';

class PostDetailServices {
  final BaseApiService _api = BaseApiService();

  Future<ApiResponse> getBlinkDetail({required String blinkId}) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      final response = await _api.get(
        'mobile/social/blinks/$blinkId',
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Post Detail Response: ${response.data}");

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: "Success",
        );
      }
      return ApiResponse(success: false, message: "Failed to fetch detail");
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse> blockUser({required String userId}) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      print("Block API calling with userId: $userId");

      final response = await _api.post(
        'mobile/social/blinks/users/block',
        {'userId': userId},
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Block User StatusCode: ${response.statusCode}");
      print("Block User Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          data: response.data,
          message:
              response.data['data']['message'] ?? "User blocked successfully",
        );
      }
      return ApiResponse(success: false, message: "Failed to block user");
    } catch (e, stack) {
      print("Block Service Error: $e");
      print("Block Service Stack: $stack");
      return handleDioError(e);
    }
  }
}
