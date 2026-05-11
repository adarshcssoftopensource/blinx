import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class SubmitProofServices {
  final String baseUrl =
      "https://civicfind-api-staging-110912028053.us-central1.run.app";

  // Sends notes as a form field and photos as multipart files
  Future<dynamic> submitProof({
    required String token,
    required String missionId,
    required String notes,
    required List<File> photos,
  }) async {
    final url = Uri.parse("$baseUrl/mobile/missions/$missionId/submit-proof");

    final request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['notes'] = notes;

    // Attach each photo as a multipart file
    for (final file in photos) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photos',
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body);
  }
}
