class MissionDetailModel {
  final String id;
  final String title;
  final String description;

  final String duration;
  final String difficulty;

  final int credits;
  final int reputation;
  final double serviceHours;

  final String locationName;
  final String locationAddress;
  final double latitude;
  final double longitude;

  final bool canClaim;

  final bool profileComplete;
  final bool backgroundCheck;
  final bool physicalCapable;

  final int minPhotos;
  final int minNotesLength;

  MissionDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.credits,
    required this.reputation,
    required this.serviceHours,
    required this.locationName,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.canClaim,
    required this.profileComplete,
    required this.backgroundCheck,
    required this.physicalCapable,
    required this.minPhotos,
    required this.minNotesLength,
  });

  factory MissionDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final mission = data['mission'] ?? {};
    final userStatus = data['userStatus'] ?? {};

    final rewards = mission['rewards'] ?? {};
    final location = mission['location'] ?? {};
    final req = mission['requirements'] ?? {};
    final submission = mission['submissionConfig'] ?? {};

    return MissionDetailModel(
      id: mission['id']?.toString() ?? "",

      title: mission['title']?.toString() ?? "",
      description: mission['description']?.toString() ?? "",
      duration: mission['duration']?.toString() ?? "",
      difficulty: mission['difficulty']?.toString() ?? "",

      credits: rewards['credits'] ?? 0,
      reputation: rewards['reputation'] ?? 0,
      serviceHours: (rewards['serviceHours'] ?? 0).toDouble(),

      locationName: location['name']?.toString() ?? "",
      locationAddress: location['address']?.toString() ?? "",
      latitude: (location['latitude'] ?? 0).toDouble(),
      longitude: (location['longitude'] ?? 0).toDouble(),

      canClaim: userStatus['canClaim'] ?? false,

      // IMPORTANT FIX HERE
      profileComplete: userStatus['isProfileComplete'] ?? false,

      backgroundCheck: req['backgroundCheck'] ?? false,
      physicalCapable: req['physicalCapable'] ?? false,

      minPhotos: submission['minPhotos'] ?? 0,
      minNotesLength: submission['minNotesLength'] ?? 0,
    );
  }
}
