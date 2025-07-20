import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/models/user.dart';

class EmployeeResultsScreen extends StatelessWidget {
  const EmployeeResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final assessmentService = Provider.of<AssessmentService>(context);
    final results = List<AssessmentResult>.from(authService.currentUser?.assessmentResults ?? []);
    results.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));

    final assessmentMap = {
      for (var assessment in assessmentService.assessments) assessment.id: assessment,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    'No Results Yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your assessment results will appear here after you complete them.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'Assessment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF3730A3),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Score',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF3730A3),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF3730A3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      final assessment = assessmentMap[result.assessmentId];
                      final didPass = result.score >= 75;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
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
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                assessment?.title ?? 'Unknown Assessment',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1E293B),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: didPass
                                      ? const Color(0xFF34D399).withOpacity(0.13)
                                      : const Color(0xFFF87171).withOpacity(0.13),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  '${result.score.toStringAsFixed(0)}%',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: didPass
                                        ? const Color(0xFF047857)
                                        : const Color(0xFF991B1B),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: didPass
                                          ? const Color(0xFFDCFCE7)
                                          : const Color(0xFFFEE2E2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          didPass
                                              ? Icons.check_circle_outline
                                              : Icons.highlight_off,
                                          color: didPass
                                              ? const Color(0xFF16A34A)
                                              : const Color(0xFFDC2626),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          didPass ? 'Passed' : 'Failed',
                                          style: TextStyle(
                                            color: didPass
                                                ? const Color(0xFF166534)
                                                : const Color(0xFF991B1B),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
