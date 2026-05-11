class UserProfileResponse {
  final UserProfileData data;

  UserProfileResponse({required this.data});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      data: UserProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserProfileData {
  final bool status;
  final String message;
  final User user;

  UserProfileData({
    required this.status,
    required this.message,
    required this.user,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String? image;
  final bool isProfileComplete;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.isProfileComplete = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }
}
