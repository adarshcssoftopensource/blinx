class MissionModel {
  final String id;
  final String title;
  final String description;
  final String locationName;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String duration;
  final String difficulty;
  final int credits;
  final int reputation;
  final double serviceHours;
  final List<String> tags;
  final bool isFeatured;
  final String publishedAt;
  final String applicationStatus;

  MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.locationName,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.duration,
    required this.difficulty,
    required this.credits,
    required this.reputation,
    required this.serviceHours,
    required this.tags,
    required this.isFeatured,
    required this.publishedAt,
    required this.applicationStatus,
  });

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final rewards = json['rewards'] ?? {};

    return MissionModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',

      locationName: location['name'] ?? '',
      locationAddress: location['address'] ?? '',

      latitude: _parseStaticDouble(location['latitude']),
      longitude: _parseStaticDouble(location['longitude']),

      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? '',

      credits: rewards['credits'] ?? 0,
      reputation: rewards['reputation'] ?? 0,
      serviceHours: _parseStaticDouble(rewards['serviceHours']),

      tags: List<String>.from(json['tags'] ?? []),
      isFeatured: json['isFeatured'] ?? false,

      publishedAt: json['publishedAt'] ?? '',
      applicationStatus:
          json['applicationStatus']?.toString() ?? 'View Details',
    );
  }

  // Static safe parser (Required for factory usage)
  static double _parseStaticDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
