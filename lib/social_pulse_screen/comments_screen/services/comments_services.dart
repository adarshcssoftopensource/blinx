import 'dart:convert';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

class CommentsServices {
  final BaseApiService baseApiService = BaseApiService();

  // GET comments
  Future<CommentsApiResponse> getComments({
    required String token,
    required String blinkId,
    int page = 1,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/$blinkId/comments?page=$page',
      );

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("Get Comments Status: ${response.statusCode}");
      print("Get Comments Body: ${response.body}");

      final jsonData = json.decode(response.body);

      return CommentsApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      print("Get Comments Error: $e");
      return CommentsApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  Future<CommentsApiResponse> addComment({
    required String token,
    required String blinkId,
    required String content,
    String? parentId,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/$blinkId/comments',
      );
      final body = {'content': content};

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      final jsonData = json.decode(response.body);

      return CommentsApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      return CommentsApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  // DELETE comment
  Future<CommentsApiResponse> deleteComment({
    required String token,
    required String blinkId,
    required String commentId,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/$blinkId/comments/$commentId',
      );

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = json.decode(response.body);

      return CommentsApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      return CommentsApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  // POST reply
  Future<CommentsApiResponse> addReply({
    required String token,
    required String blinkId,
    required String commentId,
    required String content,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/$blinkId/comments/$commentId/replies',
      );

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'content': content}),
      );

      final jsonData = json.decode(response.body);

      return CommentsApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      return CommentsApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  // DELETE reply
  Future<CommentsApiResponse> deleteReply({
    required String token,
    required String blinkId,
    required String commentId,
    required String replyId,
  }) async {
    try {
      final uri = Uri.parse(
        '${baseApiService.baseUrl}mobile/social/blinks/$blinkId/comments/$commentId/replies/$replyId',
      );

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      final jsonData = json.decode(response.body);

      return CommentsApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      return CommentsApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  // POST toggle like on blink
  Future<CommentsApiResponse> toggleLike({
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

      final jsonData = json.decode(response.body);

      return CommentsApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'],
      );
    } catch (e) {
      return CommentsApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }
}

class CommentsApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;

  CommentsApiResponse({required this.success, this.data, this.message});
}
