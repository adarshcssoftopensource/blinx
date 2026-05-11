import 'dart:convert';

import 'package:http/http.dart' as http;

class MissionActivityServices {
  final String baseUrl =
      "https://civicfind-api-staging-110912028053.us-central1.run.app";

  // GET /mobile/missions/{id}/activity
  Future<dynamic> getMissionActivity({
    required String token,
    required String missionId,
  }) async {
    final url = Uri.parse("$baseUrl/mobile/missions/$missionId/activity");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    return jsonDecode(response.body);
  }
}
