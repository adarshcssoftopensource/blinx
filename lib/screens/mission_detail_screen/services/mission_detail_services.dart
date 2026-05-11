import 'dart:convert';

import 'package:http/http.dart' as http;

class MissionDetailServices {
  final String baseUrl =
      "https://civicfind-api-staging-110912028053.us-central1.run.app";

  Future<dynamic> getMissionDetail({
    required String token,
    required String missionId,
  }) async {
    final url = "$baseUrl/mobile/missions/$missionId";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    return jsonDecode(response.body);
  }

  // Claim (start) a mission — POST /mobile/missions/{id}/claim
  Future<dynamic> claimMission({
    required String token,
    required String missionId,
  }) async {
    final url = "$baseUrl/mobile/missions/$missionId/claim";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({}),
    );

    return jsonDecode(response.body);
  }
}
