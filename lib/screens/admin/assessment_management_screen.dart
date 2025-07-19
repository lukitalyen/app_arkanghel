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
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AssessmentService>(
              builder: (context, assessmentService, child) {
                final assessments = assessmentService.assessments;
                if (assessments.isEmpty) {
                  return const Center(child: Text('No assessments found.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  itemCount: assessments.length,
                  itemBuilder: (context, index) {
                    final assessment = assessments[index];
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFDBEAFE),
                          child: Icon(Icons.library_books, color: Color(0xFF2563EB)),
                        ),
                        title: Text(
                          assessment.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B)),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${assessment.questions.length} Questions',
                                style: const TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('Chapter: ${assessment.chapterId}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_rounded, color: Color(0xFF2563EB)),
                              onPressed: () => _navigateToAddEditScreen(context, assessment),
                              tooltip: 'Edit',
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                              onPressed: () => _deleteAssessment(context, assessment.id),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(context),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Assessment',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
