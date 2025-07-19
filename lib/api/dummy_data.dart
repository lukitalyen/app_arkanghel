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
      Chapter(id: 'ch1', title: 'Introduction to Data Architecture', description: 'Data architecture is the foundation...', pdfUrl: null, videoUrl: null),
      Chapter(id: 'ch2', title: 'Data Modeling Concepts', description: 'Understanding data models...', pdfUrl: null, videoUrl: null),
    ],
  ),
  Workstream(
    id: 'ws2',
    title: 'Boiler Digital Twin',
    description: 'Explore digital twin technology for boiler systems.',
    imageUrl: 'https://example.com/boiler-twin.jpg',
    isPublished: true,
    chapters: [
      Chapter(id: 'ch3', title: 'Digital Twin Fundamentals', description: 'What is a digital twin...', pdfUrl: null, videoUrl: null),
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
  User(id: 'user1', email: 'john.doe@company.com', fullName: 'John Doe', role: UserRole.employee, dateCreated: DateTime.now().subtract(const Duration(days: 30))),
  User(id: 'user2', email: 'jane.smith@company.com', fullName: 'Jane Smith', role: UserRole.employee, dateCreated: DateTime.now().subtract(const Duration(days: 25))),
  User(id: 'user3', email: 'admin@company.com', fullName: 'Admin User', role: UserRole.admin, dateCreated: DateTime.now().subtract(const Duration(days: 60))),
  User(id: 'user4', email: 'mike.johnson@company.com', fullName: 'Mike Johnson', role: UserRole.employee, dateCreated: DateTime.now().subtract(const Duration(days: 20))),
  User(id: 'user5', email: 'sarah.wilson@company.com', fullName: 'Sarah Wilson', role: UserRole.employee, dateCreated: DateTime.now().subtract(const Duration(days: 15))),
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
  LeaderboardEntry(userId: 'user1', userName: 'John Doe', score: 95.5, rank: 1),
  LeaderboardEntry(userId: 'user2', userName: 'Jane Smith', score: 92.0, rank: 2),
  LeaderboardEntry(userId: 'user4', userName: 'Mike Johnson', score: 88.5, rank: 3),
  LeaderboardEntry(userId: 'user5', userName: 'Sarah Wilson', score: 85.0, rank: 4),
];
