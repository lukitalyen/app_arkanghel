import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LeaderboardService with ChangeNotifier {
  final AuthService _authService;
  final ContentService _contentService;
  List<LeaderboardEntry> _leaderboard = [];

  LeaderboardService(this._authService, this._contentService) {
    _authService.addListener(_updateLeaderboard);
    _contentService.addListener(_updateLeaderboard);
    _updateLeaderboard();
  }

  List<LeaderboardEntry> get leaderboard => _leaderboard;

  void _updateLeaderboard() {
    final users = _authService.users
        .where((u) => u.role == UserRole.employee)
        .toList();
    final totalChapters = _contentService.workstreams
        .expand((w) => w.chapters)
        .length;

    if (totalChapters == 0) {
      _leaderboard = [];
      notifyListeners();
      return;
    }

    List<LeaderboardEntry> entries = [];
    for (var user in users) {
      final progress = user.completedChapterIds.length / totalChapters;
      // Calculate average score from assessment results
      double averageScore = 0;
      if (user.assessmentResults.isNotEmpty) {
        averageScore =
            user.assessmentResults.map((r) => r.score).reduce((a, b) => a + b) /
            user.assessmentResults.length;
      }

      entries.add(
        LeaderboardEntry(
          userId: user.id,
          userName: user.fullName,
          score: averageScore, // Using average score for now
          progress: progress,
          rank: 0, // Rank will be assigned after sorting
        ),
      );
    }

    // Sort by progress (desc), then by score (desc)
    entries.sort((a, b) {
      int progressCompare = (b.progress ?? 0).compareTo(a.progress ?? 0);
      if (progressCompare != 0) return progressCompare;
      return b.score.compareTo(a.score);
    });

    // Assign ranks
    _leaderboard = List.generate(entries.length, (index) {
      final entry = entries[index];
      return LeaderboardEntry(
        userId: entry.userId,
        userName: entry.userName,
        score: entry.score,
        progress: entry.progress,
        rank: index + 1,
      );
    });

    notifyListeners();
  }

  void addScore(String userId, String userName, double score) {
    final existingIndex = _leaderboard.indexWhere(
      (entry) => entry.userId == userId,
    );

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
      _leaderboard.add(
        LeaderboardEntry(
          userId: userId,
          userName: userName,
          score: score,
          rank: 1, // Will be recalculated
        ),
      );
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

  void updateScore(String userId, double newScore) {
    final index = _leaderboard.indexWhere((entry) => entry.userId == userId);
    if (index != -1) {
      final entry = _leaderboard[index];
      _leaderboard[index] = LeaderboardEntry(
        userId: entry.userId,
        userName: entry.userName,
        score: newScore,
        rank: entry.rank,
      );
      _updateRanks();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authService.removeListener(_updateLeaderboard);
    _contentService.removeListener(_updateLeaderboard);
    super.dispose();
  }
}
