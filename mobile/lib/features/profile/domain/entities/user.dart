import 'package:equatable/equatable.dart';

/// User entity - pure Dart class with no Flutter dependencies
/// Represents a user account in the domain layer
class User extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String address;
  final int bonusPoints;
  final String password;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.bonusPoints,
    required this.password,
  });

  @override
  List<Object?> get props => [id, name, phone, address, bonusPoints, password];

  @override
  String toString() {
    return 'User(id: $id, name: $name, phone: $phone, address: $address, bonusPoints: $bonusPoints)';
  }
}
