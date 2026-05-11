class TopicModel {
  final String id;
  final String name;
  final String slug;
  final String color;
  final String icon;

  TopicModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.icon,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      color: json['color'],
      icon: json['icon'],
    );
  }
}
