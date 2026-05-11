class MissionActivityEvent {
  final String type;
  final String at;
  final String description;
  final String? submissionId;
  final int? photoCount;
  final int? notesLength;

  MissionActivityEvent({
    required this.type,
    required this.at,
    required this.description,
    this.submissionId,
    this.photoCount,
    this.notesLength,
  });

  factory MissionActivityEvent.fromJson(Map<String, dynamic> json) {
    return MissionActivityEvent(
      type: json['type']?.toString() ?? '',
      at: json['at']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      submissionId: json['submissionId']?.toString(),
      photoCount: json['photoCount'] is int ? json['photoCount'] : null,
      notesLength: json['notesLength'] is int ? json['notesLength'] : null,
    );
  }
}

class MissionActivityRewards {
  final int credits;
  final int reputation;
  final int serviceHours;

  MissionActivityRewards({
    required this.credits,
    required this.reputation,
    required this.serviceHours,
  });

  factory MissionActivityRewards.fromJson(Map<String, dynamic> json) {
    return MissionActivityRewards(
      credits: json['credits'] is int ? json['credits'] : 0,
      reputation: json['reputation'] is int ? json['reputation'] : 0,
      serviceHours: json['serviceHours'] is int ? json['serviceHours'] : 0,
    );
  }
}

class MissionActivityModel {
  final String missionId;
  final String missionTitle;
  final String locationName;
  final String locationAddress;
  final List<MissionActivityEvent> events;
  final MissionActivityRewards rewards;

  MissionActivityModel({
    required this.missionId,
    required this.missionTitle,
    required this.locationName,
    required this.locationAddress,
    required this.events,
    required this.rewards,
  });

  factory MissionActivityModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final mission = data['mission'] ?? {};
    final location = mission['location'] ?? {};
    final eventsList = data['events'] as List? ?? [];
    final rewardsJson = data['rewards'] ?? {};

    // DEBUG

    final parsedLocationName = location['name']?.toString() ?? '';
    final parsedLocationAddress = location['address']?.toString() ?? '';

    return MissionActivityModel(
      missionId: mission['id']?.toString() ?? '',
      missionTitle: mission['title']?.toString() ?? '',
      locationName: parsedLocationName,
      locationAddress: parsedLocationAddress,
      events: eventsList.map((e) => MissionActivityEvent.fromJson(e)).toList(),
      rewards: MissionActivityRewards.fromJson(rewardsJson),
    );
  }
}
