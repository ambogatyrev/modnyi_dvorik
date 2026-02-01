import 'package:equatable/equatable.dart';

/// User entity - pure Dart class with no Flutter dependencies
/// Represents a user account in the domain layer
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final int bonusPoints;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.bonusPoints,
  });

  @override
  List<Object?> get props => [id, name, email, bonusPoints];

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, bonusPoints: $bonusPoints)';
  }
}
