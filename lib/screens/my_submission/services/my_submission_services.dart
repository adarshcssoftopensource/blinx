import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:blinx_mobile/screens/my_submission/model/my_submission_model.dart';
import 'package:blinx_mobile/utils/screens/string_constants.dart';

import '../../../business_logic/api_response.dart';
import '../../../business_logic/store_services.dart';

class MySubmissionService {
  // Base API services instance for making HTTP requests
  final BaseApiService baseApiService = BaseApiService();

  Future<ApiResponse<MySubmissionsResponse?>> getSMySubmissionService() async {
    // Retrieve stored auth token before making the API call

    var authToken = await StoreServices.getAccessToken();
    try {
      // GET request to fetch user's submissions with auth headers
      var response = await baseApiService.get(
        "mobile/marketplace/my-submissions",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      // Parse and return response if status is success, else return failure
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: AppConstants.mySubmissionsFetched,
          data: MySubmissionsResponse.fromJson(response.data),
        );
      } else {
        return ApiResponse(
          success: false,
          message: AppConstants.somethingWentWrong,
        );
      }
    } catch (e) {
      // Handle Dio-specific errors and wrap in ApiResponse format
      return handleDioError(e);
    }
  }
}
