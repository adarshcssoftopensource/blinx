class CreatePlanRequest {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String status;

  CreatePlanRequest({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.status = "UPCOMING",
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "startDate": startDate,
    "endDate": endDate,
    "status": status,
  };
}

class CreatePlanResponse {
  final bool status;
  final String message;
  final CreatePlanData data;

  CreatePlanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreatePlanResponse.fromJson(Map<String, dynamic> json) =>
      CreatePlanResponse(
        status: json["status"] == true,
        message: json["message"] ?? "",
        data: CreatePlanData(id: json["id"] ?? json["data"]?["id"] ?? ""),
      );
}

class CreatePlanData {
  final String id;

  CreatePlanData({required this.id});

  factory CreatePlanData.fromJson(Map<String, dynamic> json) =>
      CreatePlanData(id: json["id"] ?? "");
}

// Upcoming Plans List

class UpcomingPlan {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int itemCount;
  final String status;
  final String createdAt;

  UpcomingPlan({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.itemCount,
    required this.status,
    required this.createdAt,
  });

  factory UpcomingPlan.fromJson(Map<String, dynamic> json) => UpcomingPlan(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    startDate: json["startDate"] != null
        ? DateTime.parse(json["startDate"])
        : DateTime.now(),
    endDate: json["endDate"] != null
        ? DateTime.parse(json["endDate"])
        : DateTime.now(),
    itemCount: json["itemCount"] ?? 0,
    status: json["status"] ?? "",
    createdAt: json["createdAt"] ?? "",
  );

  String get formattedDates {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return "${months[startDate.month]} ${startDate.day} – "
        "${months[endDate.month]} ${endDate.day}, ${endDate.year}";
  }
}

class UpcomingPlansResponse {
  final bool status;
  final String message;
  final List<UpcomingPlan> data;

  UpcomingPlansResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpcomingPlansResponse.fromJson(Map<String, dynamic> json) =>
      UpcomingPlansResponse(
        status: json["status"] == true,
        message: json["message"] ?? "",
        data: (json["data"] as List? ?? [])
            .map((e) => UpcomingPlan.fromJson(e))
            .toList(),
      );
}

// Single Upcoming Plan Details
class UpcomingPlanDetailsResponse {
  final bool status;
  final String message;
  final UpcomingPlanDetails data;

  UpcomingPlanDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpcomingPlanDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingPlanDetailsResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: UpcomingPlanDetails.fromJson(json["data"] ?? {}),
    );
  }
}

class UpcomingPlanDetails {
  final String id;
  final String title;
  final String description;
  final String userId;
  final String status;
  final String startDate;
  final String endDate;
  final String? ownerId;
  final String? ownerLabel;
  final String createdAt;
  final String updatedAt;
  final List<UpcomingPlanItem> items;

  UpcomingPlanDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.ownerId,
    required this.ownerLabel,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory UpcomingPlanDetails.fromJson(Map<String, dynamic> json) {
    return UpcomingPlanDetails(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      userId: json["userId"] ?? "",
      status: json["status"] ?? "",
      startDate: json["startDate"] ?? "",
      endDate: json["endDate"] ?? "",
      ownerId: json["ownerId"],
      ownerLabel: json["ownerLabel"],
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      items: (json["items"] as List? ?? [])
          .map((e) => UpcomingPlanItem.fromJson(e))
          .toList(),
    );
  }
}

class UpcomingPlanItem {
  final String id;
  final String planId;
  final String externalId;
  final String type;
  final String name;
  final String locationName;
  final String thumbnailUrl;
  final String createdAt;
  final String updatedAt;

  UpcomingPlanItem({
    required this.id,
    required this.planId,
    required this.externalId,
    required this.type,
    required this.name,
    required this.locationName,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpcomingPlanItem.fromJson(Map<String, dynamic> json) {
    return UpcomingPlanItem(
      id: json["id"] ?? "",
      planId: json["planId"] ?? "",
      externalId: json["externalId"] ?? "",
      type: json["type"] ?? "",
      name: json["name"] ?? "",
      locationName: json["locationName"] ?? "",
      thumbnailUrl: json["thumbnailUrl"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }
}

// ─────────────────────────────────────────────
// Add Plan Item
// ─────────────────────────────────────────────

class AddPlanItemRequest {
  final List<String> externalIds;

  AddPlanItemRequest({required this.externalIds});

  Map<String, dynamic> toJson() => {"externalIds": externalIds};
}

class AddPlanItemResponse {
  final bool status;
  final String message;
  final String nextActionCue;

  AddPlanItemResponse({
    required this.status,
    required this.message,
    required this.nextActionCue,
  });

  factory AddPlanItemResponse.fromJson(Map<String, dynamic> json) =>
      AddPlanItemResponse(
        status: json["status"] == true,
        message: json["message"] ?? "",
        nextActionCue: json["nextActionCue"] ?? "",
      );
}

// ─────────────────────────────────────────────
// Saved Places
// ─────────────────────────────────────────────

class SavedPlace {
  final String id;
  final String externalId;
  final String type;
  final String name;
  final String locationName;
  final String thumbnailUrl;
  final DateTime savedAt;
  final bool isGlobal;

  SavedPlace({
    required this.id,
    required this.externalId,
    required this.type,
    required this.name,
    required this.locationName,
    required this.thumbnailUrl,
    required this.savedAt,
    required this.isGlobal,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) => SavedPlace(
    id: json["id"] ?? "",
    externalId: json["externalId"] ?? "",
    type: json["type"] ?? "",
    name: json["name"] ?? "",
    locationName: json["locationName"] ?? "",
    thumbnailUrl: json["thumbnailUrl"] ?? "",
    savedAt: json["savedAt"] != null
        ? DateTime.parse(json["savedAt"])
        : DateTime.now(),
    isGlobal: json["isGlobal"] ?? false,
  );
}

class SavedPlacesResponse {
  final bool status;
  final String message;
  final List<SavedPlace> data;

  SavedPlacesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SavedPlacesResponse.fromJson(Map<String, dynamic> json) =>
      SavedPlacesResponse(
        status: json["status"] == true,
        message: json["message"] ?? "",
        data: (json["data"] as List? ?? [])
            .map((e) => SavedPlace.fromJson(e))
            .toList(),
      );
}
