import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plans/upcoming_plan_model.dart';
import 'package:dio/dio.dart';

class UpcomingPlansService {
  final Dio _dio = Dio();

  Future<ApiResponse<List<UpcomingPlanModel>>> getUpcomingPlans({
    String search = "",
  }) async {
    try {
      final token = await StoreServices.getAccessToken();

      final response = await _dio.get(
        'https://civicfind-api-staging-110912028053.us-central1.run.app/plans/upcoming',
        queryParameters: {if (search.isNotEmpty) "search": search},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = Map<String, dynamic>.from(response.data);

      if (body['status'] == true) {
        final List data = body['data'];

        final plans = data
            .map(
              (e) => UpcomingPlanModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList();

        return ApiResponse(
          success: true,
          message: body['message'] ?? 'Success',
          data: plans,
        );
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'Something went wrong',
          data: null,
        );
      }
    } catch (e) {
      return handleDioError<List<UpcomingPlanModel>>(e);
    }
  }
}
