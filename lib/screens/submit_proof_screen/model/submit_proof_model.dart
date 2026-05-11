class SubmitProofModel {
  final String id;
  final String applicationId;
  final List<String> photos;
  final String notes;
  final String status;
  final String submittedAt;

  SubmitProofModel({
    required this.id,
    required this.applicationId,
    required this.photos,
    required this.notes,
    required this.status,
    required this.submittedAt,
  });

  factory SubmitProofModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final submission = data['submission'] ?? {};

    return SubmitProofModel(
      id: submission['id']?.toString() ?? '',
      applicationId: submission['applicationId']?.toString() ?? '',
      photos: List<String>.from(submission['photos'] ?? []),
      notes: submission['notes']?.toString() ?? '',
      status: submission['status']?.toString() ?? '',
      submittedAt: submission['submittedAt']?.toString() ?? '',
    );
  }
}
