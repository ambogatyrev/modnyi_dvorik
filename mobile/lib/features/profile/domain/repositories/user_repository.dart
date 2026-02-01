import '../entities/user.dart';

/// User repository interface
/// Defines contracts for user data operations in the domain layer
abstract class UserRepository {
  /// Get the current user profile
  Future<User> getUserProfile();

  /// Get user by ID
  Future<User?> getUserById(String id);

  /// Update user profile
  Future<void> updateUserProfile(User user);
}
