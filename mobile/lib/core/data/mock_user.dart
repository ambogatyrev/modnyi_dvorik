import '../../features/profile/data/models/user_model.dart';

/// Mock user data matching the web application
/// User: Анна Петрова with 1250 bonus points
const UserModel mockUser = UserModel(
  id: '1',
  name: 'Анна Петрова',
  email: 'anna.petrova@mail.ru',
  bonusPoints: 1250,
);

/// Get current user (mock)
UserModel getCurrentUser() {
  return mockUser;
}

/// Get user by ID (mock)
UserModel? getUserById(String id) {
  if (id == mockUser.id) {
    return mockUser;
  }
  return null;
}
