class ShareModel {
  final int shareCount;

  ShareModel({required this.shareCount});

  factory ShareModel.fromJson(Map<String, dynamic> json) {
    return ShareModel(shareCount: json['shareCount'] ?? 0);
  }
}

class ShareLinksModel {
  final String copyLink;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String twitter;

  ShareLinksModel({
    required this.copyLink,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.twitter,
  });

  factory ShareLinksModel.fromJson(Map<String, dynamic> json) {
    final String originalLink = json['copyLink'] ?? '';

    String deepLink = originalLink;
    try {
      final uri = Uri.parse(originalLink);
      final segments = uri.pathSegments;
      if (segments.length >= 2 && segments[0] == 'blinks') {
        deepLink = 'blinx://blinks/${segments[1]}';
      }
    } catch (_) {}

    return ShareLinksModel(
      copyLink: deepLink,
      whatsapp: json['whatsapp'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      twitter: json['twitter'] ?? '',
    );
  }
}
