import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';

class ReportServices {
  final BaseApiService _api = BaseApiService();

  Future<ApiResponse> reportBlink({
    required String blinkId,
    required String reason,
    required String description,
  }) async {
    try {
      final token = await StoreServices.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse(success: false, message: "Token not found");
      }

      final response = await _api.post(
        'mobile/social/blinks/$blinkId/report',
        {'reason': reason, 'description': description},
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Report Blink StatusCode: ${response.statusCode}");
      print("Report Blink Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          data: response.data,
          message:
              response.data['data']['message'] ?? "Blink reported successfully",
        );
      }
      return ApiResponse(success: false, message: "Failed to report blink");
    } catch (e, stack) {
      print("Report Service Error: $e");
      print("Report Service Stack: $stack");
      return handleDioError(e);
    }
  }
}
