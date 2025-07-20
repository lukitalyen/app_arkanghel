import 'dart:math';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/auth_service.dart';
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
        content: const Text(
          'Do you want to reset all leaderboard scores? This action cannot be undone.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes, Reset'),
            onPressed: () {
              Provider.of<LeaderboardService>(
                context,
                listen: false,
              ).resetScores();
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
        content: const Text(
          'Do you want to remove this user from the leaderboard?',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes, Remove'),
            onPressed: () {
              Provider.of<LeaderboardService>(
                context,
                listen: false,
              ).removeUser(userId);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _editScore(BuildContext context, String userId, double currentScore) {
    final _controller = TextEditingController(
      text: currentScore.toStringAsFixed(2),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Score'),
        content: TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'New Score'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Save'),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2563EB)),
            onPressed: () {
              final entered = _controller.text.trim();
              final newScore = double.tryParse(entered);
              if (newScore == null || newScore < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid score.')),
                );
                return;
              }
              Provider.of<LeaderboardService>(
                context,
                listen: false,
              ).updateScore(userId, newScore);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardService = Provider.of<LeaderboardService>(context);
    final authService = Provider.of<AuthService>(context);
    final entries = leaderboardService.leaderboard;
    final allUsers = authService.users;

    final userMap = {for (var user in allUsers) user.id: user};

    final topThree = entries.length > 3 ? entries.sublist(0, 3) : entries;
    final theRest = entries.length > 3
        ? entries.sublist(3)
        : <LeaderboardEntry>[];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 10, 132, 231),
                  Color.fromARGB(255, 111, 125, 247),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                if (topThree.isNotEmpty)
                  _buildPodium(context, topThree, userMap),
                const SizedBox(height: 20),
                if (theRest.isNotEmpty)
                  Expanded(
                    child: _buildLeaderboardList(context, theRest, userMap),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(
    BuildContext context,
    List<LeaderboardEntry> topThree,
    Map<String, User> userMap,
  ) {
    final podiumOrder = [1, 0, 2];
    final orderedTopThree = podiumOrder
        .map((i) => i < topThree.length ? topThree[i] : null)
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final entry = orderedTopThree[index];
        if (entry == null) return const SizedBox.shrink();
        final user = userMap[entry.userId];
        return _PodiumMember(
          entry: entry,
          avatarUrl: user?.avatarUrl,
          onTap: () => _showAdminActions(context, user!, entry.progress ?? 0),
        );
      }),
    );
  }

  Widget _buildLeaderboardList(
    BuildContext context,
    List<LeaderboardEntry> entries,
    Map<String, User> userMap,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final user = userMap[entry.userId];
          if (user == null) return const SizedBox.shrink();
          return _LeaderboardListItem(
            entry: entry,
            avatarUrl: user.avatarUrl,
            onTap: () => _showAdminActions(context, user, entry.progress ?? 0),
          );
        },
      ),
    );
  }

  void _showAdminActions(BuildContext context, User user, double currentScore) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Score'),
              onTap: () {
                Navigator.of(ctx).pop();
                _editScore(context, user.id, currentScore);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.red),
              title: const Text(
                'Remove from Leaderboard',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _removeUser(context, user.id);
              },
            ),
          ],
        );
      },
    );
  }
}

class _PodiumMember extends StatelessWidget {
  final LeaderboardEntry entry;
  final String? avatarUrl;
  final VoidCallback onTap;

  const _PodiumMember({
    required this.entry,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank;
    final height = rank == 1 ? 140.0 : (rank == 2 ? 110.0 : 90.0);
    final progress = (entry.progress ?? 0) * 100;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: rank == 1 ? 35 : 30,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: CircleAvatar(
                    radius: rank == 1 ? 32 : 27,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                  ),
                ),
                if (rank == 1)
                  Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Transform.rotate(
                        angle: -pi / 12,
                        child: const Icon(
                          Icons.emoji_events,
                          color: Color(0xFFFFD700),
                          size: 30,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.userName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Container(
              width: 90,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rank.toString(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardListItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final String? avatarUrl;
  final VoidCallback onTap;

  const _LeaderboardListItem({
    required this.entry,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (entry.progress ?? 0) * 100;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              entry.rank.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 22,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 79, 81, 221).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${progress.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 81, 221),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
