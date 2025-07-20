import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/leaderboard_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopUserList extends StatelessWidget {
  const TopUserList({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardService = Provider.of<LeaderboardService>(context);
    final authService = Provider.of<AuthService>(context);
    final entries = leaderboardService.leaderboard;
    final allUsers = authService.users;

    final userMap = {for (var user in allUsers) user.id: user};
    final topThree = entries.length > 3 ? entries.sublist(0, 3) : entries;

    if (topThree.isEmpty) {
      return const Center(child: Text('No users on the leaderboard yet.'));
    }

    return _buildPodium(context, topThree, userMap);
  }

  Widget _buildPodium(
    BuildContext context,
    List<LeaderboardEntry> topThree,
    Map<String, User> userMap,
  ) {
    final podiumOrder = [1, 0, 2];
    final orderedTopThree = podiumOrder.map((i) => i < topThree.length ? topThree[i] : null).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        final entry = orderedTopThree[index];
        if (entry == null) return const SizedBox.shrink();
        final user = userMap[entry.userId];
        return _PodiumMember(
          entry: entry,
          avatarUrl: user?.avatarUrl,
        );
      }),
    );
  }
}

class _PodiumMember extends StatelessWidget {
  final LeaderboardEntry entry;
  final String? avatarUrl;

  const _PodiumMember({
    required this.entry,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank;
    final height = rank == 1 ? 120.0 : (rank == 2 ? 100.0 : 80.0);
    final progress = (entry.progress ?? 0) * 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: rank == 1 ? 30 : 25,
          backgroundColor: _getBorderColor(rank).withOpacity(0.5),
          child: CircleAvatar(
            radius: rank == 1 ? 27 : 22,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null ? const Icon(Icons.person, color: Colors.grey) : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.userName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${progress.toStringAsFixed(0)}% Progress',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: _getBarColor(rank),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              rank.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBarColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }

  Color _getBorderColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.transparent;
    }
  }
}
