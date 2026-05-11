import 'package:blinx_mobile/utils/screens/string_constants.dart';

class MarketplaceApplication {
  final String id;
  final String status;
  final String applicationStatus;
  final String title;
  final String description;
  final String grows;
  final int credits;

  MarketplaceApplication({
    required this.id,
    required this.status,
    required this.applicationStatus,
    required this.title,
    required this.description,
    required this.grows,
    required this.credits,
  });

  factory MarketplaceApplication.fromJson(Map<String, dynamic> json) {
    return MarketplaceApplication(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? AppConstants.statusOpen,
      applicationStatus:
          json['applicationStatus']?.toString() ??
          json['application_status']?.toString() ??
          AppConstants.viewDetails,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      grows:
          json['type']?.toString() ??
          json['role']?.toString() ??
          json['category']?.toString() ??
          AppConstants.technicalAnalyst,
      credits: _parseInt(json['rewardCredit'] ?? json['credits']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
