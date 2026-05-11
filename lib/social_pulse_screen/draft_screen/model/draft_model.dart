class DraftModel {
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
  final DraftTopic topic;
  final DraftAuthor author;
  bool isLiked;

  DraftModel({
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
    this.isLiked = false,
  });

  factory DraftModel.fromJson(Map<String, dynamic> json) {
    return DraftModel(
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
      topic: DraftTopic.fromJson(json['topic']),
      author: DraftAuthor.fromJson(json['author']),
    );
  }
}

class DraftTopic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  DraftTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory DraftTopic.fromJson(Map<String, dynamic> json) {
    return DraftTopic(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      color: json['color'] ?? '#FFFFFF',
      icon: json['icon'] ?? '',
    );
  }
}

class DraftAuthor {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;

  DraftAuthor({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
  });

  factory DraftAuthor.fromJson(Map<String, dynamic> json) {
    return DraftAuthor(
      id: json['id'],
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? false,
    );
  }
}
