import '../../features/profile/data/models/user_model.dart';

/// Mock in-memory user storage for MVP stage
/// This simulates persistent storage but data is lost when app restarts
class MockUserStorage {
  static final MockUserStorage _instance = MockUserStorage._internal();
  factory MockUserStorage() => _instance;
  MockUserStorage._internal();

  UserModel _currentUser = const UserModel(
    id: '1',
    name: 'Анна Петрова',
    phone: '+7 (999) 123-45-67',
    address: 'Москва, ул. Пушкина, д. 10, кв. 5',
    bonusPoints: 1250,
    password: 'password123',
  );

  /// Get current user
  UserModel getCurrentUser() => _currentUser;

  /// Get user by ID
  UserModel? getUserById(String id) {
    if (id == _currentUser.id) return _currentUser;
    return null;
  }

  /// Update user profile
  void updateUser(UserModel user) {
    _currentUser = user;
  }
}
