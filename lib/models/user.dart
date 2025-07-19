enum UserRole { admin, employee }

class User {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String? avatarUrl;
  final DateTime dateCreated;
  final List<String> assignedWorkstreamIds;
  final List<String> completedChapterIds;
  final List<AssessmentResult> assessmentResults;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.dateCreated,
    this.assignedWorkstreamIds = const [],
    this.completedChapterIds = const [],
    this.assessmentResults = const [],
  });
}

class AssessmentResult {
  final String assessmentId;
  final double score;
  final DateTime dateTaken;

  AssessmentResult({
    required this.assessmentId,
    required this.score,
    required this.dateTaken,
  });
}
