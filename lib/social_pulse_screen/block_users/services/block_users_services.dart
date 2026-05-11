import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';

class BlockUsersService {
  final BaseApiService _api = BaseApiService();

  Future<ApiResponse> getBlockedUsers() async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      final response = await _api.get(
        'mobile/social/blinks/users/blocked',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: "Success",
        );
      }
      return ApiResponse(
        success: false,
        message: "Failed to fetch blocked users",
      );
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse> unblockUser({required String userId}) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      final response = await _api.delete(
        'mobile/social/blinks/users/block/$userId',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          data: response.data,
          message:
              response.data['data']['message'] ?? "User unblocked successfully",
        );
      }
      return ApiResponse(success: false, message: "Failed to unblock user");
    } catch (e) {
      return handleDioError(e);
    }
  }
}
