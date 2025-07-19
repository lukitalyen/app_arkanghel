import 'package:app_arkanghel/services/leaderboard_service.dart';
import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/models/assessment.dart';
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
    final List<User> users = dummyUsers
        .where((u) => u.role == UserRole.employee)
        .toList();
    final List<Assessment> assessments = dummyAssessments;
    final int totalAssessments = assessments.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final completed = user.assessmentResults
              .map((r) => r.assessmentId)
              .toSet()
              .length;
          final percent = totalAssessments == 0
              ? 0.0
              : completed / totalAssessments;
          final isComplete =
              totalAssessments > 0 && completed == totalAssessments;
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: isComplete
                    ? const Color(0xFFD1FAE5)
                    : const Color(0xFFF3F4F6),
                child: Icon(
                  isComplete
                      ? Icons.check_circle
                      : Icons.hourglass_bottom_rounded,
                  color: isComplete
                      ? const Color(0xFF059669)
                      : const Color(0xFF64748B),
                ),
              ),
              title: Text(
                user.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isComplete ? Color(0xFF059669) : Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Progress: $completed / $totalAssessments',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFFDE68A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isComplete ? 'Complete' : 'Pending',
                  style: TextStyle(
                    color: isComplete
                        ? const Color(0xFF059669)
                        : const Color(0xFFB45309),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
