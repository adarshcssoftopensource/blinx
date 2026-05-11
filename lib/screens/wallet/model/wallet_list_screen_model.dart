enum ActivityType { mission, reward, purchase, none }

class ActivityModel {
  final String title;
  final String amount;
  final String date;
  final String status;
  final ActivityType type;

  ActivityModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.type,
  });
}
