class TopicFeedModel {
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
  final TopicInfo topic;
  final AuthorInfo author;
  final bool isLikedByMe;

  TopicFeedModel({
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
    required this.isLikedByMe,
  });

  factory TopicFeedModel.fromJson(Map<String, dynamic> json) {
    return TopicFeedModel(
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
      topic: TopicInfo.fromJson(json['topic']),
      author: AuthorInfo.fromJson(json['author']),
      isLikedByMe: json['isLikedByMe'],
    );
  }
}

class TopicInfo {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  TopicInfo({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory TopicInfo.fromJson(Map<String, dynamic> json) {
    return TopicInfo(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      color: json['color'],
      icon: json['icon'],
    );
  }
}

class AuthorInfo {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  AuthorInfo({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory AuthorInfo.fromJson(Map<String, dynamic> json) {
    return AuthorInfo(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}
