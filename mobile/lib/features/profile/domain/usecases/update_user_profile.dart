import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case to update the user profile
/// Follows Clean Architecture pattern
class UpdateUserProfile {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  /// Execute the use case
  Future<void> call(User user) async {
    return await repository.updateUserProfile(user);
  }
}
