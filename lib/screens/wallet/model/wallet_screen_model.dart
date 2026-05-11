class Wallet {
  final double availableCredits;
  double? microGrantsBalance;

  Wallet({required this.availableCredits});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(availableCredits: (json['availableCredits'] ?? 0).toDouble());
  }
}

class ReputationScore {
  final String label;
  final int score;

  ReputationScore({required this.label, required this.score});

  factory ReputationScore.fromJson(Map<String, dynamic> json) {
    return ReputationScore(
      label: json['label'] ?? '',
      score: json['score'] ?? 0,
    );
  }
}

class WalletLedgerResponse {
  final bool status;
  final Wallet wallet;
  final List<ReputationScore> reputationScores;
  final List<dynamic> recentActivity;
  final int currentPage;
  final int totalPages;
  final int totalCount;

  WalletLedgerResponse({
    required this.status,
    required this.wallet,
    required this.reputationScores,
    required this.recentActivity,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
  });

  factory WalletLedgerResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return WalletLedgerResponse(
      status: data['status'] ?? false,
      wallet: Wallet.fromJson(data['wallet'] ?? {}),
      reputationScores: [
        ReputationScore.fromJson(data['reputationScores']['knowledge'] ?? {}),
        ReputationScore.fromJson(
          data['reputationScores']['safetyQuality'] ?? {},
        ),
        ReputationScore.fromJson(data['reputationScores']['buildWork'] ?? {}),
        ReputationScore.fromJson(
          data['reputationScores']['communityCare'] ?? {},
        ),
      ],
      recentActivity: data['recentActivity'] ?? [],
      currentPage: data['currentPage'] ?? 1,
      totalPages: data['totalPages'] ?? 0,
      totalCount: data['totalCount'] ?? 0,
    );
  }
}
