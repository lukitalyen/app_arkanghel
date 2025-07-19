import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:flutter/foundation.dart';

class LeaderboardService with ChangeNotifier {
  final List<LeaderboardEntry> _entries = dummyLeaderboardEntries;

  List<LeaderboardEntry> get leaderboard {
    _entries.sort((a, b) => a.rank.compareTo(b.rank));
    return _entries;
  }

  Future<void> resetScores() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // This is a simplistic reset. In a real app, you might set scores to 0.
    // For this dummy implementation, we'll just clear the list.
    _entries.clear();
    notifyListeners();
  }

  Future<void> removeUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((entry) => entry.userId == userId);
    notifyListeners();
  }
}
