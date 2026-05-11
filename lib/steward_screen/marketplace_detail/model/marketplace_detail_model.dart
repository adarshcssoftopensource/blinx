// Root response model for application detail API
class ApplicationDetailResponse {
  // Main response data wrapper
  final ApplicationDetailData? data;

  ApplicationDetailResponse({this.data});

  // Factory constructor to parse JSON into model
  factory ApplicationDetailResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ApplicationDetailResponse();
    return ApplicationDetailResponse(
      data: ApplicationDetailData.fromJson(json['data']),
    );
  }
}

// Wrapper model containing status, type and detail object
class ApplicationDetailData {
  // API status flag
  final bool? status;

  // Response type
  final String? type;

  // Actual application detail object
  final ApplicationDetail? detail;

  ApplicationDetailData({this.status, this.type, this.detail});

  // JSON parser
  factory ApplicationDetailData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ApplicationDetailData();
    return ApplicationDetailData(
      status: json['status'],
      type: json['type'],
      detail: ApplicationDetail.fromJson(json['detail']),
    );
  }
}

// Core model representing a submitted application
class ApplicationDetail {
  // final String? applicationId;
  // final String? submissionId;
  // Application ID
  final String? id;

  // Current application status (approved/rejected/pending)
  final String? status;

  // Related task information
  final TaskDetail? task;

  // Applicant information
  final ApplicantDetail? applicant;

  // Submission description provided by applicant
  final String? description;

  // List of submitted photo URLs
  final List<String> photos;

  // Submitted video URL
  final String? videoUrl;

  // Video thumbnail preview URL
  final String? videoThumbnail;

  // Submission timestamp
  final String? submittedAt;

  // Review timestamp
  final String? reviewedAt;

  // Permission flag to approve
  final bool? canApprove;
  final bool? canReject;

  ApplicationDetail({
    this.id,
    this.status,
    this.task,
    this.applicant,
    this.description,
    this.photos = const [],
    this.videoUrl,
    this.videoThumbnail,
    this.submittedAt,
    this.reviewedAt,
    this.canApprove,
    this.canReject,
  });

  // JSON parser
  factory ApplicationDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ApplicationDetail();
    return ApplicationDetail(
      id: json['id'],
      status: json['status'],
      task: TaskDetail.fromJson(json['task']),
      applicant: ApplicantDetail.fromJson(json['applicant']),
      description: json['description'],
      photos: List<String>.from(json['photos'] ?? []),
      videoUrl: json['videoUrl'],
      videoThumbnail: json['videoThumbnail'],
      submittedAt: json['submittedAt'],
      reviewedAt: json['reviewedAt'],
      canApprove: json['canApprove'],
      canReject: json['canReject'],
    );
  }
}

// Model representing task details linked to application
class TaskDetail {
  final String? id;
  final String? title;
  final String? type;
  final String? description;
  final String? definitionOfDone;
  final String? requiredProof;
  final String? rewardCredit;
  final String? eligibility;
  final List<String> tags;
  final String? status;
  final String? publishedAt;

  TaskDetail({
    this.id,
    this.title,
    this.type,
    this.description,
    this.definitionOfDone,
    this.requiredProof,
    this.rewardCredit,
    this.eligibility,
    this.tags = const [],
    this.status,
    this.publishedAt,
  });

  // JSON parser
  factory TaskDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TaskDetail();
    return TaskDetail(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      description: json['description'],
      definitionOfDone: json['definitionOfDone'],
      requiredProof: json['requiredProof'],
      rewardCredit: json['rewardCredit'],
      eligibility: json['eligibility'],
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'],
      publishedAt: json['publishedAt'],
    );
  }
}

// Model representing applicant user information
class ApplicantDetail {
  final String? id;
  final String? email;
  final String? name;
  final String? profileImage;

  // User performance & scoring metrics
  final int? reputation;
  final int? walletBalance;
  final int? knowledgeScore;
  final int? safetyQualityScore;
  final int? buildWorkScore;
  final int? communityCareScore;

  // Steward role flag
  final bool? isSteward;

  // Current user status
  final String? status;

  ApplicantDetail({
    this.id,
    this.email,
    this.name,
    this.profileImage,
    this.reputation,
    this.walletBalance,
    this.knowledgeScore,
    this.safetyQualityScore,
    this.buildWorkScore,
    this.communityCareScore,
    this.isSteward,
    this.status,
  });

  // JSON parser
  factory ApplicantDetail.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ApplicantDetail();
    return ApplicantDetail(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImage: json['profileImage'],
      reputation: json['reputation'],
      walletBalance: json['walletBalance'],
      knowledgeScore: json['knowledgeScore'],
      safetyQualityScore: json['safetyQualityScore'],
      buildWorkScore: json['buildWorkScore'],
      communityCareScore: json['communityCareScore'],
      isSteward: json['isSteward'],
      status: json['status'],
    );
  }
}
