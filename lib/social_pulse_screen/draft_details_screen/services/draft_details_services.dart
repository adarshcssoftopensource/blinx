import 'package:blinx_mobile/social_pulse_screen/draft_details_screen/model/draft_details_model.dart';
import 'package:dio/dio.dart';

class DraftDetailsServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://civicfind-api-staging-110912028053.us-central1.run.app',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<DraftDetailsModel> publishDraft({
    required String draftId,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '/mobile/social/blinks/drafts/$draftId/publish',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final blink = response.data['data']['blink'];
        return DraftDetailsModel.fromJson(blink);
      } else {
        throw Exception('Failed to publish draft');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Something went wrong');
    }
  }
}
