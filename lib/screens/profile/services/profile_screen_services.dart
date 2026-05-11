import 'package:blinx_mobile/screens/profile/model/profile_screen_model.dart';
import 'package:dio/dio.dart';

import '../../../business_logic/api_response.dart';
import '../../../business_logic/base_api_service.dart';
import '../../../business_logic/store_services.dart';

class ProfileService {
  final BaseApiService baseApiService = BaseApiService();

  Future<ApiResponse<UserProfileResponse?>> getMyProfileService() async {
    // Fetches stored access token before making the profile GET request
    var authToken = await StoreServices.getAccessToken();
    try {
      var response = await baseApiService.get(
        "profile",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      // Parses response into UserProfileResponse model on success
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: 'User profile fetched successfully',
          data: UserProfileResponse.fromJson(response.data),
        );
      } else {
        return ApiResponse(success: false, message: "Something Went Wrong");
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> profileUpdateService(
    FormData postData,
  ) async {
    try {
      // Fetches token and sends multipart PUT request to update profile
      var authToken = await StoreServices.getAccessToken();
      var response = await baseApiService.put(
        "profile",
        postData,
        headers: {"accept": "*/*", "Authorization": "Bearer $authToken"},
      );

      // Returns success or failure ApiResponse based on HTTP status code
      if (response.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: response.data['message'] ?? "Profile Updated Successfully!",
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? "Something Went Wrong",
          data: null,
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }
}
