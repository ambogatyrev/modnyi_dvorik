import '../../../../core/data/mock_user.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

/// User repository implementation using mock data
class UserRepositoryImpl implements UserRepository {
  @override
  Future<User> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Get mock user and convert to entity
    return _mapToEntity(mockUser);
  }

  @override
  Future<User?> getUserById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Get user from mock data (only mockUser with id '1' exists)
    if (id == mockUser.id) {
      return _mapToEntity(mockUser);
    }

    return null;
  }

  @override
  Future<void> updateUserProfile(User user) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, this would update the user in the backend
    // For now, we just simulate the operation
  }

  /// Map UserModel to User entity
  User _mapToEntity(UserModel model) {
    return User(
      id: model.id,
      name: model.name,
      email: model.email,
      bonusPoints: model.bonusPoints,
    );
  }
}
