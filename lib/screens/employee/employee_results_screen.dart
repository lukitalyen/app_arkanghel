import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:intl/intl.dart';

class EmployeeResultsScreen extends StatelessWidget {
  const EmployeeResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final assessmentService = Provider.of<AssessmentService>(context);
    final results = authService.currentUser?.assessmentResults ?? [];

    // Create a map for efficient lookups
    final assessmentMap = {
      for (var assessment in assessmentService.assessments) assessment.id: assessment
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Assessment Results'),
      ),
      body: results.isEmpty
          ? const Center(child: Text('You have not completed any assessments yet.'))
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                final assessment = assessmentMap[result.assessmentId];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(assessment?.title ?? 'Unknown Assessment'),
                    subtitle: Text('Taken on: ${DateFormat.yMMMd().format(result.dateTaken)}'),
                    trailing: Text(
                      '${result.score.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: result.score >= 75 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
