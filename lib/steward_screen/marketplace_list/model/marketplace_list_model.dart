// Root model for marketplace list response
class MarketplaceListModel {
  // Contains main response data
  final MarketplaceListData? data;

  MarketplaceListModel({this.data});

  // Converts JSON into MarketplaceListModel object
  factory MarketplaceListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MarketplaceListModel();
    return MarketplaceListModel(
      data: MarketplaceListData.fromJson(json['data']),
    );
  }
}

// Holds dashboard metadata and list items
class MarketplaceListData {
  // API status flag
  final bool? status;

  // Total number of dashboard items
  final int? totalItems;

  // List of marketplace dashboard items
  final List<DashboardItem> dashboardItems;

  MarketplaceListData({
    this.status,
    this.totalItems,
    this.dashboardItems = const [],
  });
  // Converts JSON into MarketplaceListData object
  factory MarketplaceListData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MarketplaceListData();
    return MarketplaceListData(
      status: json['status'],
      totalItems: json['totalItems'],
      dashboardItems:
          (json['dashboardItems'] as List<dynamic>?)
              ?.map((e) => DashboardItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// Represents individual dashboard item
class DashboardItem {
  // Unique item ID
  final String? id;
  // Type of dashboard item
  final String? type;
  // Current status of the item
  final String? status;
  // Title of the related task
  final String? taskTitle;
  // Description of the related task
  final String? taskDescription;
  // Reward credit value
  final int? rewardCredit;
  // Submission date and time
  final String? submittedAt;
  // Indicates if item can be approved
  final bool? canApprove;
  // Indicates if item can be rejected
  final bool? canReject;
  // Activity time information
  final String? activityTime;

  DashboardItem({
    this.id,
    this.type,
    this.status,
    this.taskTitle,
    this.taskDescription,
    this.rewardCredit,
    this.submittedAt,
    this.canApprove,
    this.canReject,
    this.activityTime,
  });

  // Converts JSON into DashboardItem object
  factory DashboardItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DashboardItem();
    return DashboardItem(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      taskTitle: json['taskTitle'],
      taskDescription: json['taskDescription'],
      rewardCredit: int.tryParse(json['rewardCredit']?.toString() ?? '0'),
      submittedAt: json['submittedAt'],
      canApprove: json['canApprove'],
      canReject: json['canReject'],
      activityTime: json['activityTime'],
    );
  }
}
