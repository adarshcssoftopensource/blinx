import 'package:blinx_mobile/business_logic/store_services.dart';
import 'package:blinx_mobile/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:blinx_mobile/utils/screens/snackbar_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

// Generic API response model
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});
}

// Converts Dio errors into standardized ApiResponse
ApiResponse<T> handleDioError<T>(dynamic e) {
  // Check if error is DioException
  if (e is DioException) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        StoreServices.clearAccessToken();
        StoreServices.clearStewardStatus();
        Get.offAll(SignInScreen());
        return ApiResponse(success: false, message: "Unauthorized", data: null);
      }
      final errorData = e.response?.data;

      // Extract message from backend response
      if (errorData is Map && errorData.containsKey('message')) {
        final message = errorData['message'];

        // Handle multiple error messages
        if (message is List) {
          return ApiResponse<T>(
            success: false,
            message: message.join('\n'),
            data: null,
          );
        }

        // Handle single error message
        return ApiResponse<T>(
          success: false,
          message: message.toString(),
          data: null,
        );
      } else {
        // Fallback server error message
        return ApiResponse<T>(
          success: false,
          message: "Something went wrong, please try again",
          data: null,
        );
      }
    } else {
      AppSnackbar.show(
        title: "Failed",
        message: "No Internet, please check your internet connection",
        isSuccess: false,
      );
      return ApiResponse<T>(
        success: false,
        message: "No Internet, please check your internet connection",
        data: null,
      );
    }
  } else {
    // Handle unexpected non-Dio errors
    return ApiResponse<T>(
      success: false,
      message: "Unexpected error: ${e.toString()}",
      data: null,
    );
  }
}
