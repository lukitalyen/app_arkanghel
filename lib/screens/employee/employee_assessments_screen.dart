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
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: availableAssessments.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.quiz_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Assessments Available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Complete workstream modules to unlock assessments.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: availableAssessments.length,
                      itemBuilder: (context, index) {
                        final assessment = availableAssessments[index];
                        final workstream = contentSvc.getWorkstreamById(
                          assessment.workstreamId,
                        );
                        final isCompleted = user.assessmentResults.any(
                          (r) => r.assessmentId == assessment.id,
                        );
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCompleted
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFE5E7EB),
                              width: isCompleted ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TakeAssessmentScreen(
                                      assessment: assessment,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? const Color(0xFFD1FAE5)
                                            : const Color(0xFFDBEAFE),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        isCompleted
                                            ? Icons.check_circle
                                            : Icons.quiz_outlined,
                                        color: isCompleted
                                            ? const Color(0xFF059669)
                                            : const Color(0xFF1E40AF),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            assessment.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            workstream?.title ??
                                                'Unknown Workstream',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isCompleted
                                                      ? const Color(0xFFD1FAE5)
                                                      : const Color(0xFFFEF3C7),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  isCompleted
                                                      ? 'Completed'
                                                      : 'Available',
                                                  style: TextStyle(
                                                    color: isCompleted
                                                        ? const Color(
                                                            0xFF059669,
                                                          )
                                                        : const Color(
                                                            0xFF92400E,
                                                          ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${assessment.questions.length} Questions',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF64748B),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
