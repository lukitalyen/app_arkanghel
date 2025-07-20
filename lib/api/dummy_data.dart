import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/models/leaderboard_entry.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/models/workstream.dart';

final List<Workstream> dummyWorkstreams = [
  Workstream(
    id: 'ws1',
    title: 'Data Architecture',
    description:
        'Learn about modern data architecture principles and best practices.',
    imageUrl: 'https://example.com/data-architecture.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch1',
        title: 'Introduction to Data Architecture',
        description:
            'Data architecture is the foundation of modern data systems. This chapter provides an overview of the key concepts and principles.',
        
      ),
      Chapter(
        id: 'ch2',
        title: 'Data Modeling Concepts',
        description:
            'Learn the fundamentals of data modeling, including relational and dimensional models, and how to apply them in real-world scenarios.',
        
      ),
      Chapter(
        id: 'ch3',
        title: 'Data Warehousing Fundamentals',
        description:
            'Explore data warehousing concepts, ETL processes, and how to design efficient data warehouse architectures.',
        
      ),
      Chapter(
        id: 'ch4',
        title: 'Big Data Technologies',
        description:
            'Understanding big data technologies like Hadoop, Spark, and NoSQL databases for handling large-scale data processing.',
        
      ),
      Chapter(
        id: 'ch5',
        title: 'Data Governance & Quality',
        description:
            'Learn about data governance frameworks, data quality management, and establishing data stewardship practices.',
        
      ),
      Chapter(
        id: 'ch6',
        title: 'Cloud Data Architecture',
        description:
            'Modern cloud-based data architecture patterns, including data lakes, data mesh, and serverless architectures.',
        
      ),
    ],
  ),
  Workstream(
    id: 'ws2',
    title: 'Boiler Digital Twin',
    description: 'Explore digital twin technology for boiler systems.',
    imageUrl: 'https://example.com/boiler-twin.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch7',
        title: 'Digital Twin Fundamentals',
        description:
            'An introduction to digital twin technology, its applications, and its role in modern industry. This chapter covers the core concepts and benefits.',
        
      ),
      Chapter(
        id: 'ch8',
        title: 'Boiler System Components',
        description:
            'Understanding the key components of boiler systems, their functions, and how they interact within the overall system.',
        
      ),
      Chapter(
        id: 'ch9',
        title: 'Sensor Integration & IoT',
        description:
            'Learn how to integrate sensors and IoT devices to collect real-time data from boiler systems for digital twin modeling.',
        
      ),
      Chapter(
        id: 'ch10',
        title: 'Real-time Data Processing',
        description:
            'Processing and analyzing real-time data streams from boiler systems to maintain accurate digital twin representations.',
        
      ),
      Chapter(
        id: 'ch11',
        title: 'Predictive Maintenance',
        description:
            'Using digital twin data to predict maintenance needs, optimize performance, and prevent unexpected failures.',
        
      ),
      Chapter(
        id: 'ch12',
        title: 'Performance Optimization',
        description:
            'Leveraging digital twin insights to optimize boiler performance, efficiency, and operational parameters.',
        
      ),
    ],
  ),
  Workstream(
    id: 'ws3',
    title: 'Anomaly Detection',
    description: 'Learn advanced anomaly detection techniques.',
    imageUrl: 'https://example.com/anomaly-detection.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch13',
        title: 'Introduction to Anomaly Detection',
        description:
            'Understanding what anomalies are, why they matter, and the different types of anomaly detection approaches.',
        
      ),
      Chapter(
        id: 'ch14',
        title: 'Statistical Methods',
        description:
            'Statistical approaches to anomaly detection including z-score, modified z-score, and statistical process control.',
        
      ),
      Chapter(
        id: 'ch15',
        title: 'Machine Learning Approaches',
        description:
            'Machine learning techniques for anomaly detection including isolation forests, one-class SVM, and autoencoders.',
        
      ),
      Chapter(
        id: 'ch16',
        title: 'Time Series Anomaly Detection',
        description:
            'Specialized techniques for detecting anomalies in time series data, including seasonal decomposition and LSTM networks.',
        
      ),
      Chapter(
        id: 'ch17',
        title: 'Real-time Anomaly Detection',
        description:
            'Implementing real-time anomaly detection systems with streaming data processing and alert mechanisms.',
        
      ),
      Chapter(
        id: 'ch18',
        title: 'Evaluation & Tuning',
        description:
            'Methods for evaluating anomaly detection performance, handling false positives, and tuning detection thresholds.',
        
      ),
    ],
  ),
  Workstream(
    id: 'ws4',
    title: 'Unified Health Management System',
    description: 'Comprehensive health management system overview.',
    imageUrl: 'https://example.com/health-management.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch19',
        title: 'Health Management System Overview',
        description:
            'Introduction to unified health management systems, their components, and how they integrate across different domains.',
        
      ),
      Chapter(
        id: 'ch20',
        title: 'Asset Health Monitoring',
        description:
            'Techniques and technologies for continuous monitoring of asset health, including condition-based monitoring.',
        
      ),
      Chapter(
        id: 'ch21',
        title: 'Health Indicators & KPIs',
        description:
            'Defining and implementing key health indicators and performance metrics for comprehensive system monitoring.',
        
      ),
      Chapter(
        id: 'ch22',
        title: 'Diagnostic Systems',
        description:
            'Advanced diagnostic systems for identifying root causes of health issues and system degradation.',
        
      ),
      Chapter(
        id: 'ch23',
        title: 'Prognostic Modeling',
        description:
            'Prognostic models for predicting future health states and remaining useful life of assets and systems.',
        
      ),
      Chapter(
        id: 'ch24',
        title: 'Integrated Health Dashboard',
        description:
            'Designing and implementing comprehensive health dashboards that provide unified views of system health.',
        
      ),
    ],
  ),
  Workstream(
    id: 'ws5',
    title: 'Asset Information & Virtual Plant',
    description: 'Asset management and virtual plant technologies.',
    imageUrl: 'https://example.com/asset-management.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch25',
        title: 'Asset Information Management',
        description:
            'Fundamentals of asset information management, including asset hierarchies, taxonomies, and data structures.',
        
      ),
      Chapter(
        id: 'ch26',
        title: 'Virtual Plant Architecture',
        description:
            'Understanding virtual plant architectures, their components, and how they mirror physical plant operations.',
        
      ),
      Chapter(
        id: 'ch27',
        title: '3D Plant Modeling',
        description:
            'Creating detailed 3D models of plant assets and infrastructure for virtual plant representations.',
        
      ),
      Chapter(
        id: 'ch28',
        title: 'Asset Lifecycle Management',
        description:
            'Managing assets throughout their entire lifecycle from design and procurement to decommissioning.',
        
      ),
      Chapter(
        id: 'ch29',
        title: 'Virtual Reality Integration',
        description:
            'Integrating VR technologies with virtual plants for immersive training and operational experiences.',
        
      ),
      Chapter(
        id: 'ch30',
        title: 'Asset Performance Analytics',
        description:
            'Advanced analytics for asset performance monitoring, optimization, and decision support in virtual environments.',
        
      ),
    ],
  ),
  Workstream(
    id: 'ws6',
    title: 'Operator Rounds',
    description: 'Efficient operator round procedures and protocols.',
    imageUrl: 'https://example.com/operator-rounds.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch31',
        title: 'Operator Rounds Fundamentals',
        description:
            'Introduction to operator rounds, their importance in plant operations, and best practices for effective rounds.',
        
      ),
      Chapter(
        id: 'ch32',
        title: 'Digital Round Systems',
        description:
            'Modern digital systems for conducting and managing operator rounds, including mobile applications and data collection.',
        
      ),
      Chapter(
        id: 'ch33',
        title: 'Route Optimization',
        description:
            'Optimizing operator round routes for efficiency, safety, and comprehensive coverage of critical assets.',
        
      ),
      Chapter(
        id: 'ch34',
        title: 'Data Collection & Analysis',
        description:
            'Effective data collection during rounds and analysis techniques for identifying trends and issues.',
        
      ),
      Chapter(
        id: 'ch35',
        title: 'Exception Handling',
        description:
            'Procedures for handling exceptions and abnormal conditions discovered during operator rounds.',
        
      ),
      Chapter(
        id: 'ch36',
        title: 'Integration with CMMS',
        description:
            'Integrating operator rounds with Computerized Maintenance Management Systems for seamless workflow.',
        
      ),
    ],
  ),
  Workstream(
    id: 'ws7',
    title: 'Change Management & Culture Transformation',
    description: 'Leading organizational change and culture transformation.',
    imageUrl: 'https://example.com/change-management.jpg',
    isPublished: true,
    chapters: [
      Chapter(
        id: 'ch37',
        title: 'Change Management Principles',
        description:
            'Fundamental principles of organizational change management, including change models and frameworks.',
        
      ),
      Chapter(
        id: 'ch38',
        title: 'Culture Assessment',
        description:
            'Methods for assessing organizational culture, identifying cultural barriers, and measuring cultural maturity.',
        
      ),
      Chapter(
        id: 'ch39',
        title: 'Stakeholder Engagement',
        description:
            'Strategies for engaging stakeholders throughout the change process, building buy-in, and managing resistance.',
        
      ),
      Chapter(
        id: 'ch40',
        title: 'Communication Strategies',
        description:
            'Effective communication strategies for change initiatives, including messaging, channels, and feedback loops.',
        
      ),
      Chapter(
        id: 'ch41',
        title: 'Training & Development',
        description:
            'Designing and implementing training programs to support culture transformation and skill development.',
        
      ),
      Chapter(
        id: 'ch42',
        title: 'Sustaining Change',
        description:
            'Strategies for sustaining change over time, embedding new behaviors, and preventing regression.',
        
      ),
    ],
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
    assignedWorkstreamIds: ['ws1', 'ws2', 'ws3', 'ws4', 'ws5', 'ws6', 'ws7'],
    assessmentResults: [
      AssessmentResult(
        assessmentId: 'assessment1',
        score: 100,
        dateTaken: DateTime.now().subtract(const Duration(days: 10)),
      ),
      AssessmentResult(
        assessmentId: 'assessment2',
        score: 95,
        dateTaken: DateTime.now().subtract(const Duration(days: 9)),
      ),
    ],
  ),
  // Other employees: assigned to at least 5 published workstreams
  User(
    id: 'user2',
    email: 'jane.smith@company.com',
    fullName: 'Jane Smith',
    role: UserRole.employee,
    dateCreated: DateTime.now().subtract(const Duration(days: 25)),
    assignedWorkstreamIds: ['ws1', 'ws2', 'ws3', 'ws4', 'ws5'],
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
    assignedWorkstreamIds: ['ws1', 'ws2', 'ws3', 'ws4', 'ws5'],
  ),
  User(
    id: 'user5',
    email: 'sarah.wilson@company.com',
    fullName: 'Sarah Wilson',
    role: UserRole.employee,
    dateCreated: DateTime.now().subtract(const Duration(days: 15)),
    assignedWorkstreamIds: ['ws1', 'ws2', 'ws3', 'ws4', 'ws5'],
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
          'To delete data',
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
          'A network',
        ],
        correctAnswerIndex: 0,
      ),
    ],
  ),
];

final List<LeaderboardEntry> dummyLeaderboard = [
  // John Doe: 2/2 assessments complete
  LeaderboardEntry(
    userId: 'user1',
    userName: 'John Doe',
    score: 95.5,
    rank: 1,
    progress: 1.0,
  ),
  // Jane Smith: 0/2 assessments complete
  LeaderboardEntry(
    userId: 'user2',
    userName: 'Jane Smith',
    score: 92.0,
    rank: 2,
    progress: 0.0,
  ),
  // Mike Johnson: 0/2 assessments complete
  LeaderboardEntry(
    userId: 'user4',
    userName: 'Mike Johnson',
    score: 88.5,
    rank: 3,
    progress: 0.0,
  ),
  // Sarah Wilson: 0/2 assessments complete
  LeaderboardEntry(
    userId: 'user5',
    userName: 'Sarah Wilson',
    score: 85.0,
    rank: 4,
    progress: 0.0,
  ),
];
