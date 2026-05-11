class ViewSubmitData {
  final String missionId;
  final String missionTitle;
  final String duration;
  final String difficulty;
  final String submissionId;
  final List<String> photos;
  final String notes;
  final String status;
  final String submittedAt;

  ViewSubmitData({
    required this.missionId,
    required this.missionTitle,
    required this.duration,
    required this.difficulty,
    required this.submissionId,
    required this.photos,
    required this.notes,
    required this.status,
    required this.submittedAt,
  });

  factory ViewSubmitData.fromJson(Map<String, dynamic> json) {
    final mission = json['mission'] ?? {};
    final submission = json['submission'] ?? {};

    return ViewSubmitData(
      missionId: mission['id']?.toString() ?? '',
      missionTitle: mission['title']?.toString() ?? '',
      duration: mission['duration']?.toString() ?? '',
      difficulty: mission['difficulty']?.toString() ?? '',
      submissionId: submission['id']?.toString() ?? '',
      photos: List<String>.from(submission['photos'] ?? []),
      notes: submission['notes']?.toString() ?? '',
      status: submission['status']?.toString() ?? '',
      submittedAt: submission['submittedAt']?.toString() ?? '',
    );
  }
}
