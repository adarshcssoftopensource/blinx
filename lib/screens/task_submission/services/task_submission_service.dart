import 'dart:io';

import 'package:blinx_mobile/business_logic/base_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../../../business_logic/api_response.dart';
import '../../../business_logic/store_services.dart';
import 'task_submission_response.dart';

class TaskSubmissionService {
  // Dio instance configured with 60 second timeout for large file uploads
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  final BaseApiService baseApiService = BaseApiService();

  Future<TaskSubmissionResponse> submitWork({
    required String applicationId,
    required String description,
    File? videoFile,
    List<File>? photos,
    required String token,
  }) async {
    try {
      final formData = FormData();

      // Adds the text description field to the multipart form data
      formData.fields.add(MapEntry('description', description));

      if (videoFile != null) {
        final fileName = basename(videoFile.path);

        debugPrint('Uploading video: $fileName');

        // Attaches the video file to form data with correct media type
        formData.files.add(
          MapEntry(
            'video',
            await MultipartFile.fromFile(
              videoFile.path,
              filename: fileName,
              contentType: _getMediaType(fileName),
            ),
          ),
        );
      }

      if (photos != null && photos.isNotEmpty) {
        // Iterates and attaches each photo file to the form data
        for (final photo in photos) {
          final photoName = basename(photo.path);

          debugPrint('Uploading photo: $photoName');

          formData.files.add(
            MapEntry(
              'photos',
              await MultipartFile.fromFile(
                photo.path,
                filename: photoName,
                contentType: _getMediaType(photoName),
              ),
            ),
          );
        }
      }

      debugPrint('FORM FIELDS => ${formData.fields}');
      debugPrint(
        'FORM FILE KEYS => ${formData.files.map((e) => e.key).toList()}',
      );

      // Posts the multipart form data to the submit-work endpoint with auth header
      final response = await _dio.post(
        '${baseApiService.baseUrl}mobile/marketplace/applications/$applicationId/submit-work',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      debugPrint(' BACKEND RESPONSE => ${response.data}');
      debugPrint('API SUCCESS => ${response.data}');

      // Parses the successful response into a typed TaskSubmissionResponse model
      return TaskSubmissionResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('DIO STATUS => ${e.response?.statusCode}');
      debugPrint('DIO ERROR => ${e.response?.data}');

      // Extracts error message from response body if available, else uses default
      final message = e.response?.data is Map<String, dynamic>
          ? e.response?.data['message']?.toString() ?? 'Upload failed'
          : 'Upload failed';

      return TaskSubmissionResponse(success: false, message: message);
    } catch (e) {
      debugPrint('EXCEPTION => $e');

      return TaskSubmissionResponse(
        success: false,
        message: 'Unexpected error occurred',
      );
    }
  }

  // Resolves the correct MediaType based on the file extension
  MediaType _getMediaType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();

    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');

      case 'png':
        return MediaType('image', 'png');

      case 'mp4':
        return MediaType('video', 'mp4');

      case 'mov':
        return MediaType('video', 'quicktime');

      case '3gp':
        return MediaType('video', '3gpp');

      default:
        return MediaType('application', 'octet-stream');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> submitTaskApiService(
    FormData postData, {
    String? applicationId,
  }) async {
    // Retrieves the stored access token before making the API call
    var authToken = await StoreServices.getAccessToken();

    try {
      // Sends multipart POST request to the submit-work endpoint
      var response = await baseApiService.multipartPost(
        "mobile/marketplace/applications/$applicationId/submit-work",
        postData,
        headers: {"accept": "*/*", "Authorization": "Bearer $authToken"},
      );

      // Returns success or failure ApiResponse based on HTTP status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<Map<String, dynamic>>(
          success: true,
          message: response.data['message'] ?? "Task Submitted Successfully!",
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
}
