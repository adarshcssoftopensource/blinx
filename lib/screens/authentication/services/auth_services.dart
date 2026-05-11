import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:dio/dio.dart';

import '../../../business_logic/api_response.dart';

class AuthServices {
  final BaseApiService baseApiService = BaseApiService();

  Future<ApiResponse<Map<String, dynamic>>> signUpApiServiceWithImage(
    FormData postData,
  ) async {
    try {
      var response = await baseApiService.multipartPost(
        "auth/sign_up",
        postData,
        headers: {"accept": "*/*"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: response.data['message'] ?? "OTP Sent to your Email.",
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: "Something Went Wrong",
          data: null,
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> loginApiService(
    Map<String, dynamic> postData,
  ) async {
    try {
      final response = await baseApiService.post(
        "auth/login",
        postData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<Map<String, dynamic>>(
          success: response.data['status'] ?? true,
          message: response.data['message'] ?? '',
          data: response.data['data'],
        );
      } else {
        return ApiResponse(success: false, message: "Something went wrong");
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> socialLoginApiService(
    Map<dynamic, dynamic> postData,
  ) async {
    try {
      var response = await baseApiService.post(
        "auth/social-login",
        postData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: response.data['message'] ?? "Login Successfully",
          data: response.data,
        );
      } else {
        return ApiResponse(
          success: false,
          message: "Something Went Wrong",
          data: null,
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<String?>> forgotPasswordApi(
    Map<String, dynamic> postData,
  ) async {
    try {
      var response = await baseApiService.post(
        "auth/forgot-password",
        postData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? "Reset email sent",
        );
      } else {
        return ApiResponse(success: false, message: "Something went wrong");
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<String?>> resendOTPApi(
    Map<String, dynamic> postData,
  ) async {
    try {
      var response = await baseApiService.post(
        "auth/resend-otp",
        postData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? "Resend OTP Successfully",
        );
      } else {
        return ApiResponse(success: false, message: "Something went wrong");
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  // Verify OTP API
  Future<ApiResponse<String?>> verifyOtpApi(
    Map<String, dynamic> postData,
  ) async {
    try {
      var response = await baseApiService.post(
        "auth/verify-otp",
        postData,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? "OTP verified successfully",
        );
      } else {
        return ApiResponse(
          success: false,
          message: response.data['message'] ?? "Invalid OTP",
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtpSignUpApi(
    Map<String, dynamic> postData,
  ) async {
    try {
      final response = await baseApiService.post(
        "auth/verify-sign_up-otp",
        postData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>? ?? {};

        final Map<String, dynamic> innerData =
            responseData['data'] as Map<String, dynamic>? ?? {};
        innerData['isSteward'] = innerData['isSteward'] == true;

        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message:
              responseData['message'] ??
              innerData['message'] ??
              "OTP verified successfully",
          data: innerData,
        );
      } else {
        return ApiResponse<Map<String, dynamic>>(
          success: false,
          message: response.data['message']?.toString() ?? "Invalid OTP",
          data: {},
        );
      }
    } catch (e) {
      return handleDioError(e);
    }
  }

  Future<ApiResponse<String?>> resetPasswordApi(
    Map<String, dynamic> postData,
  ) async {
    try {
      var response = await baseApiService.post(
        "auth/reset-password",
        postData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: response.data['message'] ?? "Password reset successfully",
        );
      } else {
        return ApiResponse(success: false, message: "Something went wrong");
      }
    } catch (e) {
      return handleDioError(e);
    }
  }
}
