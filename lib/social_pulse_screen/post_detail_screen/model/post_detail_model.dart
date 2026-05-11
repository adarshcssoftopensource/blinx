class PostDetailModel {
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
  final PostDetailTopic topic;
  final PostDetailAuthor author;
  final bool isLikedByMe;
  final bool isReportedByMe;

  PostDetailModel({
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
    required this.isReportedByMe,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) {
    return PostDetailModel(
      id: json['id'] ?? '',
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
      createdAt: json['createdAt'] ?? '',
      topic: PostDetailTopic.fromJson(json['topic'] ?? {}),
      author: PostDetailAuthor.fromJson(json['author'] ?? {}),
      isLikedByMe: json['isLikedByMe'] ?? false,
      isReportedByMe: json['isReportedByMe'] ?? false,
    );
  }
}

class PostDetailTopic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  PostDetailTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory PostDetailTopic.fromJson(Map<String, dynamic> json) {
    return PostDetailTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      color: json['color'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class PostDetailAuthor {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  PostDetailAuthor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory PostDetailAuthor.fromJson(Map<String, dynamic> json) {
    return PostDetailAuthor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}

class RelatedTopic {
  final String id;
  final String name;
  final String slug;
  final int blinkCount;

  RelatedTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.blinkCount,
  });

  factory RelatedTopic.fromJson(Map<String, dynamic> json) {
    return RelatedTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      blinkCount: json['_count']?['blinks'] ?? 0,
    );
  }
}
