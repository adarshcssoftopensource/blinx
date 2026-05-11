class NearbySafetyModel {
  final String id;
  final String content;
  final String? imageUrl;
  final String visibility;
  final String status;
  final double latitude;
  final double longitude;
  final String locationName;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final String createdAt;
  final double distanceKm;
  final NearbyTopicModel topic;
  final NearbyAuthorModel author;
  final bool isLikedByMe;

  NearbySafetyModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.visibility,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.createdAt,
    required this.distanceKm,
    required this.topic,
    required this.author,
    required this.isLikedByMe,
  });

  factory NearbySafetyModel.fromJson(Map<String, dynamic> json) {
    return NearbySafetyModel(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      visibility: json['visibility'],
      status: json['status'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['locationName'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      shareCount: json['shareCount'],
      createdAt: json['createdAt'],
      distanceKm: (json['distanceKm'] as num).toDouble(),
      topic: NearbyTopicModel.fromJson(json['topic']),
      author: NearbyAuthorModel.fromJson(json['author']),
      isLikedByMe: json['isLikedByMe'],
    );
  }
}

class NearbyTopicModel {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  NearbyTopicModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory NearbyTopicModel.fromJson(Map<String, dynamic> json) {
    return NearbyTopicModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      color: json['color'],
      icon: json['icon'],
    );
  }
}

class NearbyAuthorModel {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  NearbyAuthorModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory NearbyAuthorModel.fromJson(Map<String, dynamic> json) {
    return NearbyAuthorModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}
