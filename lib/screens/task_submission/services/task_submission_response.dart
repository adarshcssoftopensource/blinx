class TaskSubmissionResponse {
  final bool success;
  final String message;
  final SubmittedWork? submittedWork;

  TaskSubmissionResponse({
    required this.success,
    required this.message,
    this.submittedWork,
  });

  factory TaskSubmissionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final detail = data?['detail'];
    final submission = detail?['submission'];

    return TaskSubmissionResponse(
      success: data?['status'] == true,
      message: 'Task submitted successfully',
      submittedWork: submission != null
          ? SubmittedWork.fromJson(submission)
          : null,
    );
  }
}

class SubmittedWork {
  final String id;
  final List<String> photos;
  final String? videoUrl;
  final String description;
  final DateTime submittedAt;
  final DateTime? reviewedAt;

  SubmittedWork({
    required this.id,
    required this.photos,
    this.videoUrl,
    required this.description,
    required this.submittedAt,
    this.reviewedAt,
  });

  factory SubmittedWork.fromJson(Map<String, dynamic> json) {
    return SubmittedWork(
      id: json['id']?.toString() ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      videoUrl: json['videoUrl']?.toString(),
      description: json['description']?.toString() ?? '',
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : DateTime.now(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
    );
  }
}
