import 'package:blinx_mobile/utils/screens/string_constants.dart';

class SubmitWorkResponse {
  final bool status;
  final String message;
  final String? applicationId;

  SubmitWorkResponse({
    required this.status,
    required this.message,
    this.applicationId,
  });

  factory SubmitWorkResponse.fromJson(Map<String, dynamic> json) {
    return SubmitWorkResponse(
      status: json['data']['status'] ?? false,
      message: json['data']['message'] ?? AppConstants.noMessageAvailable,
      applicationId: json['data']['applicationId'],
    );
  }
}
