class UpcomingPlanModel {
  final String id;
  final String title;
  final String startDate;
  final String endDate;
  final int itemCount;

  UpcomingPlanModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.itemCount,
  });

  factory UpcomingPlanModel.fromJson(Map<String, dynamic> json) {
    return UpcomingPlanModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      itemCount: json['itemCount'] ?? 0,
    );
  }
}
