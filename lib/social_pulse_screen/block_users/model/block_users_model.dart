class BlockedUserModel {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;

  BlockedUserModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      isVerified: json['isVerified'] ?? false,
    );
  }
}
