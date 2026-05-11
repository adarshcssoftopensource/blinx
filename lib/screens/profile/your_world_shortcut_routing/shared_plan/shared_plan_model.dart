class SharedPlanModel {
  final String id;
  final String title;
  final String ownerLabel;
  final int itemCount;
  final String lastUpdated;

  SharedPlanModel({
    required this.id,
    required this.title,
    required this.ownerLabel,
    required this.itemCount,
    required this.lastUpdated,
  });

  factory SharedPlanModel.fromJson(Map<String, dynamic> json) {
    return SharedPlanModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      ownerLabel: json['ownerLabel'] ?? '',
      itemCount: json['itemCount'] ?? 0,
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }
}
