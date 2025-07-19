import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/assessment.dart';
import 'package:flutter/foundation.dart';

class AssessmentService with ChangeNotifier {
  final List<Assessment> _assessments = dummyAssessments;

  List<Assessment> get assessments => _assessments;

  Future<void> addAssessment(Assessment assessment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _assessments.add(assessment);
    notifyListeners();
  }

  Future<void> updateAssessment(Assessment assessment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _assessments.indexWhere((a) => a.id == assessment.id);
    if (index != -1) {
      _assessments[index] = assessment;
      notifyListeners();
    }
  }

  Future<void> deleteAssessment(String assessmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _assessments.removeWhere((a) => a.id == assessmentId);
    notifyListeners();
  }

  double gradeAssessment(Assessment assessment, List<int?> selectedAnswers) {
    if (assessment.questions.isEmpty) {
      return 100.0;
    }
    int correctCount = 0;
    for (int i = 0; i < assessment.questions.length; i++) {
      if (selectedAnswers.length > i && selectedAnswers[i] == assessment.questions[i].correctAnswerIndex) {
        correctCount++;
      }
    }
    return (correctCount / assessment.questions.length) * 100;
  }
}
