class NearbyBlinxUser {
  final String userId;
  final String name;
  final String? profilePic;
  final double? distance;

  NearbyBlinxUser({
    required this.userId,
    required this.name,
    this.profilePic,
    this.distance,
  });

  factory NearbyBlinxUser.fromJson(Map<String, dynamic> json) {
    return NearbyBlinxUser(
      userId: json['userId'] ?? '',
      name: json['name'] ?? 'Unknown',
      profilePic: json['profilePic'],
      distance: json['distance']?.toDouble(),
    );
  }
}
