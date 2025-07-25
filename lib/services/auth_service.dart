import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/models/workstream.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _hasError = false;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  User? get currentUser => _currentUser;
  // Mock users
  final List<User> _users = [
    User(
      id: '1',
      fullName: 'Admin User',
      email: 'admin@aboitiz.com',
      role: UserRole.admin,
      dateCreated: DateTime.now(),
      avatarUrl: 'https://picsum.photos/seed/1/200',
    ),
    User(
      id: '2',
      fullName: 'Employee User',
      email: 'employee@aboitiz.com',
      role: UserRole.employee,
      dateCreated: DateTime.now(),
      assignedWorkstreamIds: ['1', '2'], // Assign two workstreams
      completedChapterIds: ['1-1', '2-1'], // Complete one chapter in each
      avatarUrl: 'https://picsum.photos/seed/2/200',
    ),
    User(
      id: 'user-1',
      fullName: 'John Doe',
      email: 'john.doe@aboitiz.com',
      role: UserRole.employee,
      dateCreated: DateTime.now(),
      avatarUrl: 'https://picsum.photos/seed/3/200',
    ),
    User(
      id: 'user-2',
      fullName: 'Jane Smith',
      email: 'jane.smith@aboitiz.com',
      role: UserRole.employee,
      dateCreated: DateTime.now(),
      avatarUrl: 'https://picsum.photos/seed/4/200',
    ),
    User(
      id: 'user-3',
      fullName: 'Peter Jones',
      email: 'peter.jones@aboitiz.com',
      role: UserRole.employee,
      dateCreated: DateTime.now(),
      avatarUrl: 'https://picsum.photos/seed/5/200',
    ),
    User(
      id: 'user-4',
      fullName: 'Mary Williams',
      email: 'mary.williams@aboitiz.com',
      role: UserRole.employee,
      dateCreated: DateTime.now(),
      avatarUrl: 'https://picsum.photos/seed/6/200',
    ),
    User(
      id: 'user-5',
      fullName: 'David Brown',
      email: 'david.brown@aboitiz.com',
      role: UserRole.employee,
      dateCreated: DateTime.now(),
      avatarUrl: 'https://picsum.photos/seed/7/200',
    ),
  ];

  Future<User?> login(String email, String password) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    // This is a mock authentication. In a real app, you would make an API call.
    // We're ignoring the password for this mock implementation.
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    try {
      final user = _users.firstWhere((user) => user.email == email);
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
      return null; // User not found
    }
  }

  List<User> get users => _users;

    Future<void> addUser(User user, List<Workstream> allWorkstreams) async {
    User newUser = user;
    if (user.role == UserRole.employee) {
      final publishedWorkstreamIds = allWorkstreams
          .where((w) => w.isPublished)
          .map((w) => w.id)
          .take(5)
          .toList();
      newUser = user.copyWith(assignedWorkstreamIds: publishedWorkstreamIds);
    }
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
        _users.add(newUser);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((user) => user.id == userId);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void markChapterAsComplete(String chapterId) {
    if (_currentUser != null && !_currentUser!.completedChapterIds.contains(chapterId)) {
      final updatedChapterIds = List<String>.from(_currentUser!.completedChapterIds);
      updatedChapterIds.add(chapterId);
      _currentUser = _currentUser!.copyWith(completedChapterIds: updatedChapterIds);
      // Also update the user in the main list to persist the change across sessions (in this mock setup)
      final index = _users.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _users[index] = _currentUser!;
      }
      notifyListeners();
    }
  }

  void addAssessmentResult(AssessmentResult result) {
    if (_currentUser != null) {
      final updatedResults = List<AssessmentResult>.from(_currentUser!.assessmentResults);
      updatedResults.add(result);
      _currentUser = _currentUser!.copyWith(assessmentResults: updatedResults);
      final index = _users.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _users[index] = _currentUser!;
      }
      notifyListeners();
    }
  }
}
