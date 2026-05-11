class UpcomingPlanDetailItemModel {
  final String id;
  final String name;
  final String locationName;
  final String thumbnailUrl;
  final String type;

  UpcomingPlanDetailItemModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.thumbnailUrl,
    required this.type,
  });

  factory UpcomingPlanDetailItemModel.fromJson(Map<String, dynamic> json) {
    return UpcomingPlanDetailItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      locationName: json['locationName'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class UpcomingPlanDetailModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String startDate;
  final String endDate;
  final String createdAt;
  final List<UpcomingPlanDetailItemModel> items;

  UpcomingPlanDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.items,
  });

  factory UpcomingPlanDetailModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return UpcomingPlanDetailModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      items: itemsList
          .map((e) => UpcomingPlanDetailItemModel.fromJson(e))
          .toList(),
    );
  }
}
