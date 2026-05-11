class InterestModel {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String color;
  final bool isAlreadySaved;

  InterestModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
    required this.isAlreadySaved,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#FFFFFF',
      isAlreadySaved: json['isAlreadySaved'] ?? false,
    );
  }
}
