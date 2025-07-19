import 'package:app_arkanghel/models/workstream.dart';
import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/models/leaderboard_entry.dart';

final List<Workstream> dummyWorkstreams = [
  Workstream(
    id: '1',
    title: 'Data Architecture',
    description: 'This is Workstream 1',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: true,
    chapters: [
      Chapter(id: '1-1', title: 'Chapter 1', description: 'Description for chapter 1'),
      Chapter(id: '1-2', title: 'Chapter 2', description: 'Description for chapter 2'),
    ],
  ),
  Workstream(
    id: '2',
    title: 'Boiler Digital Twin',
    description: 'This is Workstream 2',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: true,
    chapters: [
      Chapter(id: '2-1', title: 'Chapter 1', description: 'Description for chapter 1'),
      Chapter(id: '2-2', title: 'Chapter 2', description: 'Description for chapter 2'),
      Chapter(id: '2-3', title: 'Chapter 3', description: 'Description for chapter 3'),
    ],
  ),
  Workstream(
    id: '3',
    title: 'Anomaly Detection',
    description: 'This is Workstream 3',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: true,
    chapters: [
      Chapter(id: '3-1', title: 'Chapter 1', description: 'Description for chapter 1'),
    ],
  ),
  Workstream(
    id: '4',
    title: 'Unified Health Management System',
    description: 'This is Workstream 4',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: false,
    chapters: [],
  ),
  Workstream(
    id: '5',
    title: 'Asset Information & Virtual Plant',
    description: 'This is Workstream 5',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: true,
    chapters: [
      Chapter(id: '5-1', title: 'Chapter 1', description: 'Description for chapter 1'),
      Chapter(id: '5-2', title: 'Chapter 2', description: 'Description for chapter 2'),
    ],
  ),
  Workstream(
    id: '6',
    title: 'Operator Rounds',
    description: 'This is Workstream 6',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: true,
    chapters: [
      Chapter(id: '6-1', title: 'Chapter 1', description: 'Description for chapter 1'),
      Chapter(id: '6-2', title: 'Chapter 2', description: 'Description for chapter 2'),
      Chapter(id: '6-3', title: 'Chapter 3', description: 'Description for chapter 3'),
      Chapter(id: '6-4', title: 'Chapter 4', description: 'Description for chapter 4'),
    ],
  ),
  Workstream(
    id: '7',
    title: 'Change Management & Culture Transformation',
    description: 'This is Workstream 7',
    imageUrl: 'https://via.placeholder.com/150',
    isPublished: false,
    chapters: [],
  ),
];

final List<Assessment> dummyAssessments = [
  Assessment(
    id: 'A1',
    title: 'Data Architecture Basics',
    workstreamId: '1',
    chapterId: '1-1',
    questions: [
      Question(
        id: 'Q1',
        text: 'What is the primary key in a database?',
        type: QuestionType.multipleChoice,
        options: ['A unique identifier for a record', 'A foreign key', 'An index', 'A data type'],
        correctAnswerIndex: 0,
      ),
      Question(
        id: 'Q2',
        text: 'What does SQL stand for?',
        type: QuestionType.identification,
        options: [], // Identification questions have no options
        correctAnswerIndex: 0, // Not applicable, but required by model
      ),
    ],
  ),
  Assessment(
    id: 'A2',
    title: 'Digital Twin Concepts',
    workstreamId: '2',
    chapterId: '2-1',
    questions: [
      Question(
        id: 'Q3',
        text: 'A digital twin is a virtual representation of a physical object or system.',
        type: QuestionType.trueOrFalse,
        options: ['True', 'False'],
        correctAnswerIndex: 0,
      ),
    ],
  ),
];

final List<LeaderboardEntry> dummyLeaderboardEntries = [
  LeaderboardEntry(userId: 'user-1', userName: 'John Doe', score: 1500, rank: 1),
  LeaderboardEntry(userId: 'user-2', userName: 'Jane Smith', score: 1450, rank: 2),
  LeaderboardEntry(userId: 'user-3', userName: 'Peter Jones', score: 1300, rank: 3),
  LeaderboardEntry(userId: 'user-4', userName: 'Mary Williams', score: 1250, rank: 4),
  LeaderboardEntry(userId: 'user-5', userName: 'David Brown', score: 1100, rank: 5),
];
