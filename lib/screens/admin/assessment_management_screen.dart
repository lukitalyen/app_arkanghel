import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/screens/admin/add_edit_assessment_screen.dart';
import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssessmentManagementScreen extends StatelessWidget {
  const AssessmentManagementScreen({super.key});


  void _navigateToAddEditScreen(BuildContext context, [Assessment? assessment]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditAssessmentScreen(assessment: assessment),
      ),
    );
  }

  void _deleteAssessment(BuildContext context, String assessmentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to delete this assessment?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Provider.of<AssessmentService>(context, listen: false).deleteAssessment(assessmentId);
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
      body: Consumer<AssessmentService>(
        builder: (context, assessmentService, child) {
          final assessments = assessmentService.assessments;
          if (assessments.isEmpty) {
            return const Center(child: Text('No assessments found.'));
          }

          return ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final assessment = assessments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(assessment.title),
                  subtitle: Text('Chapter ID: ${assessment.chapterId} - ${assessment.questions.length} questions'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToAddEditScreen(context, assessment),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAssessment(context, assessment.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Assessment',
      ),
    );
  }
}
