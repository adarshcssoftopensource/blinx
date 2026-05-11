import 'dart:convert';
import 'dart:io';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/screens/marketplace/services/submit_work_response.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';
import 'package:http/http.dart' as http;

class MarketplaceServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<ApiResponse> getMarketplace(String token, int page, int limit) async {
    try {
      final url = Uri.parse(
        '${baseApiService.baseUrl}mobile/marketplace?page=$page&limit=$limit',
      );

      final response = await http.get(
        url,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      final jsonData = json.decode(response.body);

      return ApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['message'],
      );
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<SubmitWorkResponse> submitWork({
    required String token,
    required String applicationId,
    required String description,
    String? videoUrl,
    List<File>? photos,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}/applications/$applicationId/submit-work',
      );

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = description;

      if (videoUrl != null) {
        request.fields['videoUrl'] = videoUrl;
      }

      if (photos != null && photos.isNotEmpty) {
        for (final file in photos) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photos',
              file.path,
              filename: file.path.split('/').last,
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return SubmitWorkResponse.fromJson(jsonData['data']);
      } else {
        return SubmitWorkResponse(
          status: false,
          message:
              '${AppConstants.serverError} ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return SubmitWorkResponse(status: false, message: e.toString());
    }
  }
}

class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;

  ApiResponse({required this.success, this.data, this.message});
}
