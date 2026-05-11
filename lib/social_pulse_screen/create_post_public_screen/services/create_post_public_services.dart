import 'dart:convert';
import 'dart:io';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

class CreatePostPublicServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<CreatePostPublicApiResponse> createPublicBlink({
    required String token,
    required String content,
    required String topicId,
    required String locationName,
    required double latitude,
    required double longitude,
    bool isUrgent = false,
    File? image,
    String status = 'active',
  }) async {
    try {
      final uri = Uri.parse('${baseApiService.baseUrl}mobile/social/blinks');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['content'] = content;
      request.fields['visibility'] = 'public';
      request.fields['topicId'] = topicId;
      request.fields['locationName'] = locationName;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['status'] = status;

      print("Sending Fields: ${request.fields}");
      print("Sending status: $status");

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            filename: image.path.split('/').last,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Public Status Code: ${response.statusCode}");
      print("Public Body: ${response.body}");

      final jsonData = json.decode(response.body);

      return CreatePostPublicApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      print("Public Service Error: $e");
      return CreatePostPublicApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }
}

class CreatePostPublicApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;

  CreatePostPublicApiResponse({required this.success, this.data, this.message});
}
