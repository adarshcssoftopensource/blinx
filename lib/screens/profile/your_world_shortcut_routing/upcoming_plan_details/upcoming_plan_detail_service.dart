import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/upcoming_plan_details/upcoming_plan_detail_model.dart';
import 'package:dio/dio.dart';

class UpcomingPlanDetailService {
  final Dio _dio = Dio();

  Future<ApiResponse<UpcomingPlanDetailModel>> getUpcomingPlanDetail(
    String planId,
  ) async {
    try {
      final token = await StoreServices.getAccessToken();

      final response = await _dio.get(
        'https://civicfind-api-staging-110912028053.us-central1.run.app/plans/upcoming/$planId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      if (body['status'] == true) {
        final plan = UpcomingPlanDetailModel.fromJson(body['data']);
        return ApiResponse(
          success: true,
          message: body['message'] ?? 'Success',
          data: plan,
        );
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'Something went wrong',
          data: null,
        );
      }
    } catch (e) {
      return handleDioError<UpcomingPlanDetailModel>(e);
    }
  }
}
