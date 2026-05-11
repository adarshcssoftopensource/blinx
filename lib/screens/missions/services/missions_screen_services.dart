import 'dart:convert';

import 'package:http/http.dart' as http;

class MissionsScreenServices {
  final String baseUrl =
      "https://civicfind-api-staging-110912028053.us-central1.run.app";

  Future<dynamic> getMissions({
    required String token,
    required String status,
    required int page,
    required int limit,
  }) async {
    final url =
        "$baseUrl/mobile/missions?status=$status&page=$page&limit=$limit";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(response.body);
  }
}
