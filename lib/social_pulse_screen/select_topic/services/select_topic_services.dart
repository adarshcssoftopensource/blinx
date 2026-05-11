import 'dart:convert';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

import '../model/select_topic_model.dart';

class SelectTopicServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<SelectTopicApiResponse> getTopics({required String token}) async {
    try {
      final uri = Uri.parse('${baseApiService.baseUrl}mobile/social/topics');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Topics Status Code: ${response.statusCode}");
      print("Topics Body: ${response.body}");

      final jsonData = json.decode(response.body);

      if (jsonData['data']?['status'] == true) {
        final List topicsJson = jsonData['data']['topics'] ?? [];
        final topics = topicsJson
            .map((e) => SelectTopicModel.fromJson(e))
            .toList();

        return SelectTopicApiResponse(
          success: true,
          topics: topics,
          message: jsonData['data']['message'],
        );
      } else {
        return SelectTopicApiResponse(
          success: false,
          topics: [],
          message: jsonData['data']?['message'] ?? 'Failed to fetch topics',
        );
      }
    } catch (e) {
      return SelectTopicApiResponse(
        success: false,
        topics: [],
        message: e.toString(),
      );
    }
  }
}

class SelectTopicApiResponse {
  final bool success;
  final List<SelectTopicModel> topics;
  final String? message;

  SelectTopicApiResponse({
    required this.success,
    required this.topics,
    this.message,
  });
}
