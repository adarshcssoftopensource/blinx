class MySubmissionsResponse {
  final SubmissionData data;

  MySubmissionsResponse({required this.data});

  factory MySubmissionsResponse.fromJson(Map<String, dynamic> json) {
    return MySubmissionsResponse(
      data: SubmissionData.fromJson(json['data'] ?? {}),
    );
  }
}

class SubmissionData {
  final bool status;
  final String message;
  final List<Submission> submissions;

  SubmissionData({
    required this.status,
    required this.message,
    required this.submissions,
  });

  factory SubmissionData.fromJson(Map<String, dynamic> json) {
    return SubmissionData(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      submissions: (json['submissions'] as List? ?? [])
          .map((e) => Submission.fromJson(e))
          .toList(),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String type;
  final String rewardCredit;
  final String description;
  final String definitionOfDone;
  final String requiredProof;
  final List<String> tags;

  Task({
    required this.id,
    required this.title,
    required this.type,
    required this.rewardCredit,
    required this.description,
    required this.definitionOfDone,
    required this.requiredProof,
    required this.tags,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      rewardCredit: json['rewardCredit'] ?? '',
      description: json['description'] ?? '',
      definitionOfDone: json['definitionOfDone'] ?? '',
      requiredProof: json['requiredProof'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class Submission {
  final String submissionId;
  final Task task;
  final String status;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String description;
  final List<String> photos;
  final String? videoUrl;
  final String? reviewedById;
  final String? videoThumbnail;

  Submission({
    required this.submissionId,
    required this.task,
    required this.status,
    required this.submittedAt,
    this.reviewedAt,
    required this.description,
    required this.photos,
    this.videoUrl,
    this.reviewedById,
    this.videoThumbnail,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submissionId: json['submissionId'] ?? '',
      task: Task.fromJson(json['task'] ?? {}),
      status: json['status'] ?? '',
      submittedAt: DateTime.parse(json['submittedAt']),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      description: json['description'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      videoUrl: json['videoUrl'],
      reviewedById: json['reviewedById'],
      videoThumbnail: json['videoThumbnail'],
    );
  }
}
