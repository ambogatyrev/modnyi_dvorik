import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case to get the current user profile
/// Follows Clean Architecture pattern
class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  /// Execute the use case
  Future<User> call() async {
    return await repository.getUserProfile();
  }
}
