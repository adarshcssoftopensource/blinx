import 'dart:convert';
import 'dart:io';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

class CreatePostPrivateServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<CreatePostPrivateApiResponse> createPrivateBlink({
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
      request.fields['visibility'] = 'private';
      request.fields['topicId'] = topicId;
      request.fields['locationName'] = locationName;
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['status'] = status;

      print("Sending content: $content");
      print("Sending topicId: $topicId");
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

      print("Status Code: ${response.statusCode}");
      print("Full Body: ${response.body}");

      final jsonData = json.decode(response.body);

      return CreatePostPrivateApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      return CreatePostPrivateApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }
}

class CreatePostPrivateApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;

  CreatePostPrivateApiResponse({
    required this.success,
    this.data,
    this.message,
  });
}
