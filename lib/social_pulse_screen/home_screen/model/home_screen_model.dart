class HomeScreenModel {
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
  final HomeScreenTopic topic;
  final HomeScreenAuthor author;
  final bool isLikedByMe;

  HomeScreenModel({
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

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      visibility: json['visibility']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      locationName: json['locationName']?.toString() ?? '',
      likeCount: _parseInt(json['likeCount']),
      commentCount: _parseInt(json['commentCount']),
      shareCount: _parseInt(json['shareCount']),
      createdAt: json['createdAt']?.toString() ?? '',
      topic: HomeScreenTopic.fromJson(json['topic'] ?? {}),
      author: HomeScreenAuthor.fromJson(json['author'] ?? {}),
      isLikedByMe: json['isLikedByMe'] == true,
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

class HomeScreenTopic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  HomeScreenTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory HomeScreenTopic.fromJson(Map<String, dynamic> json) {
    return HomeScreenTopic(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      color: json['color']?.toString() ?? '#E8F1FF',
      icon: json['icon']?.toString() ?? '',
    );
  }
}

class HomeScreenAuthor {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  HomeScreenAuthor({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory HomeScreenAuthor.fromJson(Map<String, dynamic> json) {
    return HomeScreenAuthor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      profileImage: json['profileImage']?.toString() ?? '',
      isVerified: json['isVerified'] == true,
    );
  }
}
