import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:dio/dio.dart';

import '../model/application_form_model.dart';

// Service class for handling application form API calls
class ApplicationFormService {
  // Dio instance for HTTP requests
  final Dio _dio = Dio();

  // Base API services for base URL reference
  final BaseApiService baseApiService = BaseApiService();

  // Parses message from different response formats
  String parseMessage(dynamic message) {
    if (message is String) return message;
    if (message is List) return message.join('\n');
    return message.toString();
  }

  // Sends task application request to backend
  Future<ApplicationFormResponse> applyTask({
    required String taskId,
    required String whyBestFit,
    required String executionPlan,
    required String availability,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '${baseApiService.baseUrl}mobile/marketplace/$taskId/apply',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "whyBestFit": whyBestFit,
          "executionPlan": executionPlan,
          "availability": availability,
        },
      );

      // Convert API response to model
      return ApplicationFormResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle API error response
      return ApplicationFormResponse(
        status: false,
        message: e.response?.data['message'] ?? AppConstants.unknownError,
        applicationId: '',
      );
    } catch (e) {
      // Handle unexpected errors
      return ApplicationFormResponse(
        status: false,
        message: '${AppConstants.anErrorOccurred}: ${e.toString()}',
        applicationId: '',
      );
    }
  }
}
