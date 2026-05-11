class SharedPlanDetailItemModel {
  final String id;
  final String name;
  final String locationName;
  final String thumbnailUrl;
  final String type;

  SharedPlanDetailItemModel({
    required this.id,
    required this.name,
    required this.locationName,
    required this.thumbnailUrl,
    required this.type,
  });

  factory SharedPlanDetailItemModel.fromJson(Map<String, dynamic> json) {
    return SharedPlanDetailItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      locationName: json['locationName'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class SharedPlanDetailModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String startDate;
  final String endDate;
  final String createdAt;
  final List<SharedPlanDetailItemModel> items;

  SharedPlanDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.items,
  });

  factory SharedPlanDetailModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List? ?? [];
    return SharedPlanDetailModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      items: itemsList
          .map((e) => SharedPlanDetailItemModel.fromJson(e))
          .toList(),
    );
  }
}

class SaveSharedPlanResponse {
  final bool status;
  final String message;
  final String savedType;
  final String nextActionId;
  final String nextActionCue;

  SaveSharedPlanResponse({
    required this.status,
    required this.message,
    required this.savedType,
    required this.nextActionId,
    required this.nextActionCue,
  });

  factory SaveSharedPlanResponse.fromJson(Map<String, dynamic> json) {
    return SaveSharedPlanResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      savedType: json['savedType'] ?? '',
      nextActionId: json['nextActionId'] ?? '',
      nextActionCue: json['nextActionCue'] ?? '',
    );
  }
}
