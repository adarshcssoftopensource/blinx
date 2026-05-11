import 'dart:convert';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

import '../model/home_screen_model.dart';

class HomeScreenServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<HomeScreenApiResponse> getFeed({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/feed?page=$page&limit=$limit',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Feed Status Code: ${response.statusCode}");
      print("Feed Body: ${response.body}");

      final jsonData = json.decode(response.body);

      if (jsonData['data']?['status'] == true) {
        final List blinksJson = jsonData['data']['blinks'] ?? [];
        final blinks = blinksJson
            .map((e) => HomeScreenModel.fromJson(e))
            .toList();

        return HomeScreenApiResponse(
          success: true,
          blinks: blinks,
          currentPage: jsonData['data']['currentPage'] ?? 1,
          totalPages: jsonData['data']['totalPages'] ?? 1,
          totalCount: jsonData['data']['totalCount'] ?? 0,
          message: jsonData['data']['message'],
        );
      } else {
        return HomeScreenApiResponse(
          success: false,
          blinks: [],
          message: jsonData['data']?['message'] ?? 'Failed to fetch feed',
        );
      }
    } catch (e) {
      print("Feed Error: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> toggleLike({
    required String token,
    required String blinkId,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/$blinkId/like',
      );

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Toggle Like Status: ${response.statusCode}");
      print("Toggle Like Body: ${response.body}");

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'liked': jsonData['data']['liked'],
          'likeCount': jsonData['data']['likeCount'],
        };
      }
      return {'success': false};
    } catch (e) {
      print("Toggle Like Error: $e");
      return {'success': false};
    }
  }
}

class HomeScreenApiResponse {
  final bool success;
  final List<HomeScreenModel> blinks;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final String? message;

  HomeScreenApiResponse({
    required this.success,
    required this.blinks,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.message,
  });
}
