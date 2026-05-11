import 'package:blinx_mobile/utils/screens/string_constants.dart';

// Model class for application form API response
class ApplicationFormResponse {
  // Indicates success or failure status
  final bool status;
  // Response message from API
  final String message;
  // Application ID returned after submission
  final String applicationId;

  ApplicationFormResponse({
    required this.status,
    required this.message,
    required this.applicationId,
  });

  // Creates model from JSON response
  factory ApplicationFormResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {}; // Ensure 'data' exists
    return ApplicationFormResponse(
      status: data['status'] ?? false,
      message: data['message'] ?? AppConstants.noMessageAvailable,
      applicationId: data['applicationId'] ?? '',
    );
  }

  // Converts object to readable string format
  @override
  String toString() {
    return 'ApplicationFormResponse(status: $status, message: $message, applicationId: $applicationId)';
  }
}
