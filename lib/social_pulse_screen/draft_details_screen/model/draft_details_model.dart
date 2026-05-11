class DraftDetailsModel {
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
  final DateTime createdAt;
  final DraftDetailsTopic topic;
  final DraftDetailsAuthor author;

  DraftDetailsModel({
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
    required this.topic,
    required this.author,
  });

  factory DraftDetailsModel.fromJson(Map<String, dynamic> json) {
    return DraftDetailsModel(
      id: json['id'],
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      visibility: json['visibility'] ?? '',
      status: json['status'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      locationName: json['locationName'] ?? '',
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      topic: DraftDetailsTopic.fromJson(json['topic'] ?? {}),
      author: DraftDetailsAuthor.fromJson(json['author'] ?? {}),
    );
  }
}

class DraftDetailsTopic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  DraftDetailsTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory DraftDetailsTopic.fromJson(Map<String, dynamic> json) {
    return DraftDetailsTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      color: json['color'] ?? '#FFFFFF',
      icon: json['icon'] ?? '',
    );
  }
}

class DraftDetailsAuthor {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;

  DraftDetailsAuthor({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
  });

  factory DraftDetailsAuthor.fromJson(Map<String, dynamic> json) {
    return DraftDetailsAuthor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? false,
    );
  }
}
