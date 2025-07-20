import 'dart:math';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:app_arkanghel/models/user.dart';
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                if (topThree.isNotEmpty)
                  _buildPodium(context, topThree, currentUser, userMap),
                const SizedBox(height: 20),
                if (theRest.isNotEmpty)
                  _buildLeaderboardList(context, theRest, currentUser, userMap),
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
    User? currentUser,
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
          isCurrentUser: currentUser?.id == entry.userId,
          avatarUrl: user?.avatarUrl,
        );
      }),
    );
  }

  Widget _buildLeaderboardList(
    BuildContext context,
    List<LeaderboardEntry> entries,
    User? currentUser,
    Map<String, User> userMap,
  ) {
    return Expanded(
      child: Container(
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
            return _LeaderboardListItem(
              entry: entry,
              isCurrentUser: currentUser?.id == entry.userId,
              avatarUrl: user?.avatarUrl,
            );
          },
        ),
      ),
    );
  }
}

class _PodiumMember extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;
  final String? avatarUrl;

  const _PodiumMember({
    required this.entry,
    required this.isCurrentUser,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank;
    final height = rank == 1 ? 140.0 : (rank == 2 ? 110.0 : 90.0);
    final progress = (entry.progress ?? 0) * 100;

    return Container(
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
    );
  }
}

class _LeaderboardListItem extends StatelessWidget {
  final LeaderboardEntry entry;
  final bool isCurrentUser;
  final String? avatarUrl;

  const _LeaderboardListItem({
    required this.entry,
    required this.isCurrentUser,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (entry.progress ?? 0) * 100;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFFE0E7FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser
            ? Border.all(
                color: const Color.fromARGB(255, 90, 92, 231),
                width: 1.5,
              )
            : null,
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                color: Color(0xFF4338CA),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
