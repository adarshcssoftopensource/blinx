import 'dart:convert';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

class ViewSubmitServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<ViewSubmitApiResponse> getSubmission(
    String token,
    String missionId,
  ) async {
    try {
      final url = Uri.parse(
        '${baseApiService.baseUrl}mobile/missions/$missionId/submission',
      );

      final response = await http.get(
        url,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      final jsonData = json.decode(response.body);

      return ViewSubmitApiResponse(
        success: jsonData['data']?['status'] == true,
        data: jsonData['data'],
        message: jsonData['data']?['message'] ?? '',
      );
    } catch (e) {
      return ViewSubmitApiResponse(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }
}

class ViewSubmitApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String message;

  ViewSubmitApiResponse({
    required this.success,
    required this.data,
    required this.message,
  });
}
