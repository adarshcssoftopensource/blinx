class ReportModel {
  final bool status;
  final String message;

  ReportModel({required this.status, required this.message});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ReportModel(
      status: data['status'] ?? false,
      message: data['message'] ?? '',
    );
  }
}
