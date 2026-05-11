class SavedPlaceModel {
  final String id;
  final String externalId;
  final String type;
  final String name;
  final String locationName;
  final String thumbnailUrl;
  final DateTime savedAt;

  SavedPlaceModel({
    required this.id,
    required this.externalId,
    required this.type,
    required this.name,
    required this.locationName,
    required this.thumbnailUrl,
    required this.savedAt,
  });

  factory SavedPlaceModel.fromJson(Map<String, dynamic> json) {
    return SavedPlaceModel(
      id: json['id'] ?? '',
      externalId: json['externalId'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      locationName: json['locationName'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      savedAt: DateTime.parse(json['savedAt']),
    );
  }
}
