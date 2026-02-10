import '../../../../core/data/mock_user.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

/// User repository implementation using mock data
class UserRepositoryImpl implements UserRepository {
  final MockUserStorage _userStorage = MockUserStorage();

  @override
  Future<User> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    return _mapToEntity(_userStorage.getCurrentUser());
  }

  @override
  Future<User?> getUserById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final model = _userStorage.getUserById(id);
    return model != null ? _mapToEntity(model) : null;
  }

  @override
  Future<void> updateUserProfile(User user) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _userStorage.updateUser(UserModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      address: user.address,
      bonusPoints: user.bonusPoints,
      password: user.password,
    ));
  }

  /// Map UserModel to User entity
  User _mapToEntity(UserModel model) {
    return User(
      id: model.id,
      name: model.name,
      phone: model.phone,
      address: model.address,
      bonusPoints: model.bonusPoints,
      password: model.password,
    );
  }
}
