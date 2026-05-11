class CreatePostPrivateModel {
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
  final CreatePostPrivateTopic topic;
  final CreatePostPrivateAuthor author;

  CreatePostPrivateModel({
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

  factory CreatePostPrivateModel.fromJson(Map<String, dynamic> json) {
    return CreatePostPrivateModel(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      visibility: json['visibility']?.toString() ?? 'private',
      status: json['status']?.toString() ?? 'active',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      locationName: json['locationName']?.toString() ?? '',
      likeCount: _parseInt(json['likeCount']),
      commentCount: _parseInt(json['commentCount']),
      shareCount: _parseInt(json['shareCount']),
      createdAt: json['createdAt']?.toString() ?? '',
      topic: CreatePostPrivateTopic.fromJson(json['topic'] ?? {}),
      author: CreatePostPrivateAuthor.fromJson(json['author'] ?? {}),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

class CreatePostPrivateTopic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  CreatePostPrivateTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory CreatePostPrivateTopic.fromJson(Map<String, dynamic> json) {
    return CreatePostPrivateTopic(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      color: json['color']?.toString() ?? '#E8F1FF',
      icon: json['icon']?.toString() ?? '',
    );
  }
}

class CreatePostPrivateAuthor {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  CreatePostPrivateAuthor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory CreatePostPrivateAuthor.fromJson(Map<String, dynamic> json) {
    return CreatePostPrivateAuthor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
      isVerified: json['isVerified'] == true,
    );
  }
}
