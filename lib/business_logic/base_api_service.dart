import 'package:blinx_mobile/utils/screens/snackbar_helper.dart';
import 'package:dio/dio.dart';

import 'api_response.dart';

// Base API services for handling all HTTP requests
class BaseApiService {
  late final Dio _dio;
  // final String baseUrl = "https://civicfind.csdevhub.com/";`
  // String IMAGE_URL = "https://civicfind.csdevhub.com/";

  // Base URL for API requests
  final String baseUrl =
      "https://civicfind-api-staging-110912028053.us-central1.run.app/";
  // Base URL for loading images
  String IMAGE_URL =
      "https://civicfind-api-staging-110912028053.us-central1.run.app/";

  // Initializes Dio with base configuration
  BaseApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration.zero,
        receiveTimeout: Duration.zero,
        sendTimeout: Duration.zero,
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  // Handles GET API requests
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? headers,
    Options? options,
    ss,
  }) async {
    return _dio.get(endpoint, options: options ?? Options(headers: headers));
  }

  // Handles DELETE API requests
  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    return _dio.delete(endpoint, options: Options(headers: headers));
  }

  // Handles POST API requests
  Future<Response> post(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    return _dio.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  // Handles PUT API requests
  Future<Response> put(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    return _dio.put(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  // Handles PATCH API requests
  Future<Response> patch(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    return _dio.patch(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  // Handles multipart POST requests (file uploads)
  Future<Response> multipartPost(
    String endpoint,
    FormData data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  // Handling Internet Connection
  ApiResponse<T> handleDioError<T>(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        AppSnackbar.show(
          title: "Failed",
          message: "No internet connection. Please check your network.",
          isSuccess: false,
        );
        return ApiResponse(
          success: false,
          message: "No internet connection. Please check your network.",
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        AppSnackbar.show(
          title: "Failed",
          message: "Request timed out. Please try again.",
          isSuccess: false,
        );
        return ApiResponse(
          success: false,
          message: "Request timed out. Please try again.",
        );
      }
      final serverMsg = e.response?.data?['message']?.toString();
      return ApiResponse(
        success: false,
        message: serverMsg ?? "Something went wrong",
      );
    }
    return ApiResponse(success: false, message: "Something went wrong");
  }
}
