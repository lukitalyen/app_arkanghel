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

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          if (currentUser != null)
            _buildMyStatsCard(context, entries, currentUser),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final isCurrentUser =
                    currentUser != null && entry.userId == currentUser.id;
                final percent = entry.progress ?? 0.0;
                final isComplete = percent >= 1.0;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xFFE0E7FF)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCurrentUser
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E7EB),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: isComplete
                              ? const Color(0xFFD1FAE5)
                              : const Color(0xFFF3F4F6),
                          child: Text(
                            entry.rank.toString(),
                            style: TextStyle(
                              color: isComplete
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isCurrentUser)
                          const Positioned(
                            right: -2,
                            bottom: -2,
                            child: Icon(
                              Icons.star,
                              color: Color(0xFFFACC15),
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      entry.userName,
                      style: TextStyle(
                        fontWeight: isCurrentUser
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 16,
                        color: isCurrentUser
                            ? const Color(0xFF1E40AF)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete
                                ? const Color(0xFF059669)
                                : const Color(0xFF1E40AF),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              isComplete
                                  ? Icons.check_circle
                                  : Icons.hourglass_bottom_rounded,
                              color: isComplete
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF64748B),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isComplete ? 'Complete' : 'Pending',
                              style: TextStyle(
                                color: isComplete
                                    ? const Color(0xFF059669)
                                    : const Color(0xFF64748B),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Score: ${entry.score.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyStatsCard(
    BuildContext context,
    List<LeaderboardEntry> entries,
    User currentUser,
  ) {
    final myEntry = entries.firstWhere(
      (e) => e.userId == currentUser.id,
      orElse: () => entries.first,
    );
    final percent = myEntry.progress ?? 0.0;
    final isComplete = percent >= 1.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isComplete
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFF3F4F6),
                child: Text(
                  myEntry.rank.toString(),
                  style: TextStyle(
                    color: isComplete
                        ? const Color(0xFF059669)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isComplete
                              ? Icons.check_circle
                              : Icons.hourglass_bottom_rounded,
                          color: isComplete
                              ? const Color(0xFF059669)
                              : const Color(0xFF64748B),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isComplete ? 'Complete' : 'Pending',
                          style: TextStyle(
                            color: isComplete
                                ? const Color(0xFF059669)
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Score: ${myEntry.score.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(
              isComplete ? const Color(0xFF059669) : const Color(0xFF1E40AF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(percent * 100).toStringAsFixed(0)}% Complete',
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
