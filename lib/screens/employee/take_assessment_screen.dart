import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:app_arkanghel/services/auth_service.dart';

class TakeAssessmentScreen extends StatefulWidget {
  final Assessment assessment;

  const TakeAssessmentScreen({super.key, required this.assessment});

  @override
  _TakeAssessmentScreenState createState() => _TakeAssessmentScreenState();
}

class _TakeAssessmentScreenState extends State<TakeAssessmentScreen> {
  final PageController _pageController = PageController();
  late List<int?> _selectedAnswers;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(widget.assessment.questions.length, null);
  }

  void _submitAssessment() {
    final assessmentService = Provider.of<AssessmentService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final score = assessmentService.gradeAssessment(widget.assessment, _selectedAnswers);
    
    final result = AssessmentResult(
      assessmentId: widget.assessment.id,
      score: score,
      dateTaken: DateTime.now(),
    );
    
    authService.addAssessmentResult(result);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Assessment Complete'),
        content: Text('You scored ${score.toStringAsFixed(1)}%'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back from the assessment screen
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.assessment.questions;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assessment.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Question ${index + 1}/${questions.length}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(question.text, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 24),
                      if (question.options != null)
                        ...question.options!.asMap().entries.map((entry) {
                          int optionIndex = entry.key;
                          String optionText = entry.value;
                          return RadioListTile<int>(
                            title: Text(optionText),
                            value: optionIndex,
                            groupValue: _selectedAnswers[index],
                            onChanged: (value) {
                              setState(() {
                                _selectedAnswers[index] = value;
                              });
                            },
                          );
                        }).toList(),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    onPressed: () {
                      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    },
                  ),
                if (_currentPage == questions.length - 1)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Submit'),
                    onPressed: _submitAssessment,
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.white),
                  )
                else
                  TextButton.icon(
                    label: const Text('Next'),
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                       _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    },
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
