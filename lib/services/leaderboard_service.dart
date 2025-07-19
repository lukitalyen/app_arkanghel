import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:flutter/foundation.dart';

class LeaderboardService with ChangeNotifier {
  List<LeaderboardEntry> _leaderboard = List.from(dummyLeaderboard);

  List<LeaderboardEntry> get leaderboard => _leaderboard;

  void addScore(String userId, String userName, double score) {
    final existingIndex = _leaderboard.indexWhere((entry) => entry.userId == userId);
    
    if (existingIndex != -1) {
      // Update existing user's score if new score is higher
      if (score > _leaderboard[existingIndex].score) {
        _leaderboard[existingIndex] = LeaderboardEntry(
          userId: userId,
          userName: userName,
          score: score,
          rank: 1, // Will be recalculated
        );
      }
    } else {
      // Add new user
      _leaderboard.add(LeaderboardEntry(
        userId: userId,
        userName: userName,
        score: score,
        rank: 1, // Will be recalculated
      ));
    }
    
    _updateRanks();
    notifyListeners();
  }

  void removeUser(String userId) {
    _leaderboard.removeWhere((entry) => entry.userId == userId);
    _updateRanks();
    notifyListeners();
  }

  void resetScores() {
    _leaderboard.clear();
    notifyListeners();
  }

  void _updateRanks() {
    // Sort by score in descending order
    _leaderboard.sort((a, b) => b.score.compareTo(a.score));
    
    // Update ranks
    for (int i = 0; i < _leaderboard.length; i++) {
      _leaderboard[i] = LeaderboardEntry(
        userId: _leaderboard[i].userId,
        userName: _leaderboard[i].userName,
        score: _leaderboard[i].score,
        rank: i + 1,
      );
    }
  }

  LeaderboardEntry? getUserEntry(String userId) {
    try {
      return _leaderboard.firstWhere((entry) => entry.userId == userId);
    } catch (e) {
      return null;
    }
  }

  int getUserRank(String userId) {
    final entry = getUserEntry(userId);
    return entry?.rank ?? 0;
  }
}
