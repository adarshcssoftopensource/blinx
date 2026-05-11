class SelectTopicModel {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String color;
  final int blinkCount;

  SelectTopicModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
    required this.blinkCount,
  });

  factory SelectTopicModel.fromJson(Map<String, dynamic> json) {
    return SelectTopicModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      color: json['color']?.toString() ?? '#E8F1FF',
      blinkCount: json['blinkCount'] is int ? json['blinkCount'] : 0,
    );
  }
}
