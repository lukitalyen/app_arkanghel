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
      appBar: AppBar(
        title: const Text('Leaderboard Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _resetLeaderboard(context),
            tooltip: 'Reset All Scores',
          ),
        ],
      ),
      body: Consumer<LeaderboardService>(
        builder: (context, leaderboardService, child) {
          final entries = leaderboardService.leaderboard;
          if (entries.isEmpty) {
            return const Center(child: Text('Leaderboard is empty.'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(entry.rank.toString()),
                  ),
                  title: Text(entry.userName),
                  subtitle: Text('Score: ${entry.score}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeUser(context, entry.userId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
