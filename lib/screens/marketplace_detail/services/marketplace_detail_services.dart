import 'dart:convert';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:http/http.dart' as http;

import '../model/marketplace_detail_model.dart';

class MarketplaceDetailService {
  final BaseApiService baseApiService = BaseApiService();

  Future<MarketplaceDetail?> getDetail(String id, String token) async {
    try {
      final url = Uri.parse('${baseApiService.baseUrl}mobile/marketplace/$id');
      final response = await http.get(
        url,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final data = jsonData['data'];
        final taskData = data?['task'];

        if (taskData != null && taskData['id']?.toString() == id) {
          return MarketplaceDetail.fromJson(taskData);
        }
      }
    } catch (e) {}
    return null;
  }
}
