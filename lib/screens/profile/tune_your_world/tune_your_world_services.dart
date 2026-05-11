import 'dart:convert';

import 'package:http/http.dart' as http;

class TuneYourWorldServices {
  final String baseUrl =
      "https://civicfind-api-staging-110912028053.us-central1.run.app";

  Future<dynamic> saveInterests({
    required String token,
    required List<String> interestIds,
  }) async {
    final url = "$baseUrl/profile/interests";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"interestIds": interestIds}),
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> getInterests({required String token}) async {
    final url = "$baseUrl/profile/interests";

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
