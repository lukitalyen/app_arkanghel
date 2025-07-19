class LeaderboardEntry {
  final String userId;
  final String userName;
  final double score;
  final int rank;
  final double? progress; // 0.0 - 1.0, nullable for backward compatibility

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.score,
    required this.rank,
    this.progress,
  });
}
