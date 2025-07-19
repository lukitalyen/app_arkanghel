import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/leaderboard_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeLeaderboardScreen extends StatelessWidget {
  const EmployeeLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardService = Provider.of<LeaderboardService>(context);
    final authService = Provider.of<AuthService>(context);
    final entries = leaderboardService.leaderboard;
    final currentUser = authService.currentUser;

    return Scaffold(
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final isCurrentUser = currentUser != null && entry.userId == currentUser.id;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isCurrentUser ? Colors.blue.withOpacity(0.1) : null,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(entry.rank.toString()),
              ),
              title: Text(entry.userName, style: TextStyle(fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal)),
              subtitle: Text('Score: ${entry.score}'),
            ),
          );
        },
      ),
    );
  }
}
