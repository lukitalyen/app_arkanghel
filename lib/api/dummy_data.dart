import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/models/workstream.dart';

final List<Workstream> dummyWorkstreams = [
  Workstream(
    id: 'ws1',
    title: 'Data Architecture',
    description: 'Learn about modern data architecture principles and best practices.',
    imageUrl: 'https://example.com/data-architecture.jpg',
    isPublished: true,
    chapters: [
      Chapter(id: 'ch1', title: 'Introduction to Data Architecture', description: 'Data architecture is the foundation of modern data systems. This chapter provides an overview of the key concepts and principles.', pdfUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4'),
      Chapter(id: 'ch2', title: 'Data Modeling Concepts', description: 'Learn the fundamentals of data modeling, including relational and dimensional models, and how to apply them in real-world scenarios.', pdfUrl: 'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf', videoUrl: null),
    ],
  ),
  Workstream(
    id: 'ws2',
    title: 'Boiler Digital Twin',
    description: 'Explore digital twin technology for boiler systems.',
    imageUrl: 'https://example.com/boiler-twin.jpg',
    isPublished: true,
    chapters: [
      Chapter(id: 'ch3', title: 'Digital Twin Fundamentals', description: 'An introduction to digital twin technology, its applications, and its role in modern industry. This chapter covers the core concepts and benefits.', pdfUrl: 'https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
    ],
  ),
  Workstream(
    id: 'ws3',
    title: 'Anomaly Detection',
    description: 'Learn advanced anomaly detection techniques.',
    imageUrl: 'https://example.com/anomaly-detection.jpg',
    isPublished: true,
    chapters: [],
  ),
  Workstream(
    id: 'ws4',
    title: 'Unified Health Management System',
    description: 'Comprehensive health management system overview.',
    imageUrl: 'https://example.com/health-management.jpg',
    isPublished: true,
    chapters: [],
  ),
  Workstream(
    id: 'ws5',
    title: 'Asset Information & Virtual Plant',
    description: 'Asset management and virtual plant technologies.',
    imageUrl: 'https://example.com/asset-management.jpg',
    isPublished: true,
    chapters: [],
  ),
  Workstream(
    id: 'ws6',
    title: 'Operator Rounds',
    description: 'Efficient operator round procedures and protocols.',
    imageUrl: 'https://example.com/operator-rounds.jpg',
    isPublished: true,
    chapters: [],
  ),
  Workstream(
    id: 'ws7',
    title: 'Change Management & Culture Transformation',
    description: 'Leading organizational change and culture transformation.',
    imageUrl: 'https://example.com/change-management.jpg',
    isPublished: true,
    chapters: [],
  ),
];

final List<User> dummyUsers = [
  // John Doe: completed all assessments, assigned to all workstreams
  User(
    id: 'user1',
    email: 'john.doe@company.com',
    fullName: 'John Doe',
    role: UserRole.employee,
    dateCreated: DateTime.now().subtract(const Duration(days: 30)),
    assignedWorkstreamIds: [
      'ws1','ws2','ws3','ws4','ws5','ws6','ws7'
    ],
    assessmentResults: [
      AssessmentResult(assessmentId: 'assessment1', score: 100, dateTaken: DateTime.now().subtract(const Duration(days: 10))),
      AssessmentResult(assessmentId: 'assessment2', score: 95, dateTaken: DateTime.now().subtract(const Duration(days: 9))),
    ],
  ),
  // Other employees: assigned to at least 5 published workstreams
  User(
    id: 'user2',
    email: 'jane.smith@company.com',
    fullName: 'Jane Smith',
    role: UserRole.employee,
    dateCreated: DateTime.now().subtract(const Duration(days: 25)),
    assignedWorkstreamIds: ['ws1','ws2','ws3','ws4','ws5'],
  ),
  User(
    id: 'user3',
    email: 'admin@company.com',
    fullName: 'Admin User',
    role: UserRole.admin,
    dateCreated: DateTime.now().subtract(const Duration(days: 60)),
  ),
  User(
    id: 'user4',
    email: 'mike.johnson@company.com',
    fullName: 'Mike Johnson',
    role: UserRole.employee,
    dateCreated: DateTime.now().subtract(const Duration(days: 20)),
    assignedWorkstreamIds: ['ws1','ws2','ws3','ws4','ws5'],
  ),
  User(
    id: 'user5',
    email: 'sarah.wilson@company.com',
    fullName: 'Sarah Wilson',
    role: UserRole.employee,
    dateCreated: DateTime.now().subtract(const Duration(days: 15)),
    assignedWorkstreamIds: ['ws1','ws2','ws3','ws4','ws5'],
  ),
];

final List<Assessment> dummyAssessments = [
  Assessment(
    id: 'assessment1',
    title: 'Data Architecture Fundamentals',
    workstreamId: 'ws1',
    chapterId: 'ch1',
    questions: [
      Question(
        id: 'q1',
        text: 'What is the primary purpose of data architecture?',
        type: QuestionType.multipleChoice,
        options: [
          'To store data',
          'To provide a blueprint for data management',
          'To analyze data',
          'To delete data'
        ],
        correctAnswerIndex: 1,
      ),
      Question(
        id: 'q2',
        text: 'Data models are essential for understanding data relationships.',
        type: QuestionType.trueFalse,
        options: ['True', 'False'],
        correctAnswerIndex: 0,
      ),
    ],
  ),
  Assessment(
    id: 'assessment2',
    title: 'Digital Twin Basics',
    workstreamId: 'ws2',
    chapterId: 'ch3',
    questions: [
      Question(
        id: 'q3',
        text: 'A digital twin is a virtual representation of what?',
        type: QuestionType.multipleChoice,
        options: [
          'A physical object or system',
          'A database',
          'A software application',
          'A network'
        ],
        correctAnswerIndex: 0,
      ),
    ],
  ),
];

final List<LeaderboardEntry> dummyLeaderboard = [
  // John Doe: 2/2 assessments complete
  LeaderboardEntry(userId: 'user1', userName: 'John Doe', score: 95.5, rank: 1, progress: 1.0),
  // Jane Smith: 0/2 assessments complete
  LeaderboardEntry(userId: 'user2', userName: 'Jane Smith', score: 92.0, rank: 2, progress: 0.0),
  // Mike Johnson: 0/2 assessments complete
  LeaderboardEntry(userId: 'user4', userName: 'Mike Johnson', score: 88.5, rank: 3, progress: 0.0),
  // Sarah Wilson: 0/2 assessments complete
  LeaderboardEntry(userId: 'user5', userName: 'Sarah Wilson', score: 85.0, rank: 4, progress: 0.0),
];
