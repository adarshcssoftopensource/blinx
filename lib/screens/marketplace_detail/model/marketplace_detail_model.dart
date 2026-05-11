class Staff {
  final String name;

  Staff({required this.name});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(name: json['name'] ?? '');
  }
}

class MarketplaceDetail {
  final String id;
  final String title;
  final String type;
  final String description;
  final String definitionOfDone;
  final String requiredProof;
  final String rewardCredit;
  final String eligibility;
  final List<String> tags;
  final DateTime publishedAt;
  final Staff createdByStaff;
  final String applicationStatus;
  final String workSubmissionStatus;
  final String applicationId;

  MarketplaceDetail({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.definitionOfDone,
    required this.requiredProof,
    required this.rewardCredit,
    required this.eligibility,
    required this.tags,
    required this.publishedAt,
    required this.createdByStaff,
    required this.applicationStatus,
    required this.workSubmissionStatus,
    required this.applicationId,
  });

  factory MarketplaceDetail.fromJson(Map<String, dynamic> json) {
    return MarketplaceDetail(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      definitionOfDone: json['definitionOfDone'] ?? '',
      requiredProof: json['requiredProof'] ?? '',
      rewardCredit: json['rewardCredit']?.toString() ?? '0',
      eligibility: json['eligibility'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      publishedAt: DateTime.parse(json['publishedAt']),
      createdByStaff: Staff.fromJson(json['createdByStaff'] ?? {}),
      applicationStatus: json['applicationStatus'] ?? '',
      workSubmissionStatus: json['workSubmissionStatus'] ?? '',
      applicationId: json['applicationId'] ?? '',
    );
  }
}
