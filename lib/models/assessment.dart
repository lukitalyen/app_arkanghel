enum QuestionType { multipleChoice, trueFalse, shortAnswer }

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
  });

  Question copyWith({
    String? id,
    String? text,
    QuestionType? type,
    List<String>? options,
    int? correctAnswerIndex,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
    );
  }
}

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

  Assessment copyWith({
    String? id,
    String? title,
    String? workstreamId,
    String? chapterId,
    List<Question>? questions,
  }) {
    return Assessment(
      id: id ?? this.id,
      title: title ?? this.title,
      workstreamId: workstreamId ?? this.workstreamId,
      chapterId: chapterId ?? this.chapterId,
      questions: questions ?? this.questions,
    );
  }
}
