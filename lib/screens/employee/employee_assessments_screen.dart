import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/screens/employee/take_assessment_screen.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeAssessmentsScreen extends StatelessWidget {
  const EmployeeAssessmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final contentSvc = Provider.of<ContentService>(context);
    final assessmentSvc = Provider.of<AssessmentService>(context);

    final user = authService.currentUser;
    if (user == null) {
      return const Center(child: Text('Error: No user logged in.'));
    }

    final assignedWorkstreamIds = user.assignedWorkstreamIds;
    final availableAssessments = assessmentSvc.assessments
        .where((a) => assignedWorkstreamIds.contains(a.workstreamId))
        .toList();

    return Scaffold(
      body: ListView.builder(
        itemCount: availableAssessments.length,
        itemBuilder: (context, index) {
          final assessment = availableAssessments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(assessment.title),
              subtitle: Text('Workstream: ${contentSvc.getWorkstreamById(assessment.workstreamId)?.title ?? 'N/A'}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TakeAssessmentScreen(assessment: assessment),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
