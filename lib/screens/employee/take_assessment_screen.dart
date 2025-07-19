import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/leaderboard_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TakeAssessmentScreen extends StatefulWidget {
  final Assessment assessment;

  const TakeAssessmentScreen({super.key, required this.assessment});

  @override
  State<TakeAssessmentScreen> createState() => _TakeAssessmentScreenState();
}

class _TakeAssessmentScreenState extends State<TakeAssessmentScreen> {
  late List<int?> _selectedAnswers;
  int _currentQuestionIndex = 0;
  bool _isSubmitted = false;
  double? _score;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(widget.assessment.questions.length, null);
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.assessment.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _submitAssessment() {
    final assessmentService = Provider.of<AssessmentService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final leaderboardService = Provider.of<LeaderboardService>(context, listen: false);
    
    final score = assessmentService.gradeAssessment(widget.assessment, _selectedAnswers);
    
    // Add score to leaderboard
    if (authService.currentUser != null) {
      leaderboardService.addScore(
        authService.currentUser!.id,
        authService.currentUser!.fullName,
        score,
      );
      
      // Save assessment result to user profile
      final assessmentResult = AssessmentResult(
        assessmentId: widget.assessment.id,
        score: score,
        dateTaken: DateTime.now(),
      );
      authService.addAssessmentResult(assessmentResult);
    }
    
    setState(() {
      _score = score;
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return _buildResultScreen();
    }

    final currentQuestion = widget.assessment.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.assessment.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.assessment.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1} of ${widget.assessment.questions.length}',
                        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  ),
                ],
              ),
            ),

            // Question content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQuestion.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildAnswerOptions(currentQuestion),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousQuestion,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentQuestionIndex == widget.assessment.questions.length - 1
                          ? _submitAssessment
                          : _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _currentQuestionIndex == widget.assessment.questions.length - 1
                            ? 'Submit Assessment'
                            : 'Next Question',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Question question) {
    if (question.type == QuestionType.shortAnswer) {
      return TextFormField(
        decoration: InputDecoration(
          hintText: 'Enter your answer...',
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        maxLines: 3,
        onChanged: (value) {
          // For short answer, we'll store the answer as index 0 if not empty
          _selectAnswer(value.trim().isNotEmpty ? 0 : -1);
        },
      );
    }

    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedAnswers[_currentQuestionIndex] == index;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _selectAnswer(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDBEAFE) : const Color(0xFFF9FAFB),
                border: Border.all(
                  color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF9CA3AF),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResultScreen() {
    final scorePercentage = _score!.round();
    final isPassed = scorePercentage >= 70;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      isPassed ? Icons.check_circle : Icons.cancel,
                      size: 80,
                      color: isPassed ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isPassed ? 'Congratulations!' : 'Assessment Complete',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You scored $scorePercentage%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isPassed
                          ? 'Great job! You passed the assessment.'
                          : 'Keep studying and try again.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Back to Assessments',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
