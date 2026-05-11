import 'package:blinx_mobile/business_logic/api_response.dart';
import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/profile/your_world_shortcut_routing/shared_plan_detail/shared_plan_detail_model.dart';
import 'package:dio/dio.dart';

class SharedPlanDetailService {
  final Dio _dio = Dio();

  Future<ApiResponse<SharedPlanDetailModel>> getSharedPlanDetail(
    String planId,
  ) async {
    try {
      final token = await StoreServices.getAccessToken();

      final response = await _dio.get(
        'https://civicfind-api-staging-110912028053.us-central1.run.app/plans/shared/$planId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      if (body['status'] == true) {
        final plan = SharedPlanDetailModel.fromJson(body['data']);
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
      return handleDioError<SharedPlanDetailModel>(e);
    }
  }

  // Save API
  Future<ApiResponse<SaveSharedPlanResponse>> saveSharedPlan(
    String planId,
  ) async {
    try {
      final token = await StoreServices.getAccessToken();

      final response = await _dio.post(
        'https://civicfind-api-staging-110912028053.us-central1.run.app/plans/shared/$planId/save',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final body = response.data;

      if (body['status'] == true) {
        return ApiResponse(
          success: true,
          message: body['message'] ?? 'Success',
          data: SaveSharedPlanResponse.fromJson(body),
        );
      } else {
        return ApiResponse(
          success: false,
          message: body['message'] ?? 'Something went wrong',
          data: null,
        );
      }
    } catch (e) {
      return handleDioError<SaveSharedPlanResponse>(e);
    }
  }
}
