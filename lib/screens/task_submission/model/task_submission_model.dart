class SubmittedWork {
  final String id;
  final String applicationId;
  final List<String> photos;
  final String? videoUrl;
  final String description;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedById;
  final String? videofile;

  SubmittedWork({
    required this.id,
    required this.applicationId,
    required this.photos,
    this.videoUrl,
    required this.description,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedById,
    this.videofile,
  });

  factory SubmittedWork.fromJson(Map<String, dynamic> json) {
    return SubmittedWork(
      id: json['id'],
      applicationId: json['applicationId'],
      photos: List<String>.from(json['photos'] ?? []),
      videoUrl: json['videoUrl'],
      description: json['description'],
      submittedAt: DateTime.parse(json['submittedAt']),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      reviewedById: json['reviewedById'],
      videofile: json['videofile'] != null
          ? json['videofile'].toString()
          : null,
    );
  }
}

class TaskSubmissionResponse {
  final bool status;
  final String message;
  final SubmittedWork? submittedWork;

  TaskSubmissionResponse({
    required this.status,
    required this.message,
    this.submittedWork,
  });

  factory TaskSubmissionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final detail = data?['detail'] as Map<String, dynamic>?;
    final submission = detail?['submission'] as Map<String, dynamic>?;

    return TaskSubmissionResponse(
      status: data?['status'] ?? false,
      message: data?['message'] ?? '',
      submittedWork: submission != null
          ? SubmittedWork.fromJson(submission)
          : null,
    );
  }
}
