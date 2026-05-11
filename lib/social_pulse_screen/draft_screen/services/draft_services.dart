import 'package:dio/dio.dart';

import '../model/draft_model.dart';

class DraftServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://civicfind-api-staging-110912028053.us-central1.run.app',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<DraftModel>> fetchDrafts({String? token}) async {
    try {
      print("Fetching drafts with token: $token");

      final response = await _dio.get(
        '/mobile/social/blinks/my-drafts',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        // Swagger response: response.data -> { data: { blinks: [...] } }
        final Map<String, dynamic> responseData = response.data;
        final List blinks = responseData['data']['blinks'] ?? [];
        return blinks.map((e) => DraftModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch drafts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print("DioException: ${e.response?.data}");
      print("Status code: ${e.response?.statusCode}");
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    } catch (e) {
      print("General error: $e");
      throw Exception(e.toString());
    }
  }
}
