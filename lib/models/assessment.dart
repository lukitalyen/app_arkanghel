class Assessment {
  final String id;
  final String title;
  final String workstreamId;
  final String chapterId;
  final List<Question> questions;

  Assessment({
    required this.id,
    required this.title,
    required this.workstreamId,
    required this.chapterId,
    required this.questions,
  });
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String>? options; // For multiple choice
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    required this.correctAnswerIndex,
  });
}

enum QuestionType { multipleChoice, identification, trueOrFalse }
