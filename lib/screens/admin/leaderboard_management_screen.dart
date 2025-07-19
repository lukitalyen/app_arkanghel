import 'package:app_arkanghel/services/leaderboard_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardManagementScreen extends StatelessWidget {
  const LeaderboardManagementScreen({super.key});


  void _resetLeaderboard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to reset all leaderboard scores? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes, Reset'),
            onPressed: () {
              Provider.of<LeaderboardService>(context, listen: false).resetScores();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _removeUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this user from the leaderboard?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes, Remove'),
            onPressed: () {
              Provider.of<LeaderboardService>(context, listen: false).removeUser(userId);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Expanded(
            child: Consumer<LeaderboardService>(
              builder: (context, leaderboardService, child) {
                final entries = leaderboardService.leaderboard;
                if (entries.isEmpty) {
                  return const Center(child: Text('Leaderboard is empty.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: index == 0
                              ? const Color(0xFFFDE68A)
                              : index == 1
                                  ? const Color(0xFFD1FAE5)
                                  : index == 2
                                      ? const Color(0xFFDBEAFE)
                                      : const Color(0xFFF3F4F6),
                          child: Text(
                            entry.rank.toString(),
                            style: TextStyle(
                              color: index == 0
                                  ? const Color(0xFFB45309)
                                  : index == 1
                                      ? const Color(0xFF059669)
                                      : index == 2
                                          ? const Color(0xFF2563EB)
                                          : const Color(0xFF6B7280),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          entry.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                        ),
                        subtitle: Text('Score: ${entry.score}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                          onPressed: () => _removeUser(context, entry.userId),
                          tooltip: 'Remove',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _resetLeaderboard(context),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.refresh, color: Colors.white),
        tooltip: 'Reset All Scores',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
