enum UserRole { admin, employee }

class User {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;
  final UserRole role;

  final DateTime dateCreated;
  final List<String> assignedWorkstreamIds;
  final List<String> completedChapterIds;
  final List<AssessmentResult> assessmentResults;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    required this.role,

    required this.dateCreated,
    this.assignedWorkstreamIds = const [],
    this.completedChapterIds = const [],
    this.assessmentResults = const [],
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    UserRole? role,

    DateTime? dateCreated,
    List<String>? assignedWorkstreamIds,
    List<String>? completedChapterIds,
    List<AssessmentResult>? assessmentResults,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,

      dateCreated: dateCreated ?? this.dateCreated,
      assignedWorkstreamIds: assignedWorkstreamIds ?? this.assignedWorkstreamIds,
      completedChapterIds: completedChapterIds ?? this.completedChapterIds,
      assessmentResults: assessmentResults ?? this.assessmentResults,
    );
  }
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
