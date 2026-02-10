import 'package:equatable/equatable.dart';

/// User data model for profile and account information
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String address;
  final int bonusPoints;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.bonusPoints,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      bonusPoints: json['bonusPoints'] as int,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'bonusPoints': bonusPoints,
    };
  }

  /// Create a copy of UserModel with modified fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    int? bonusPoints,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      bonusPoints: bonusPoints ?? this.bonusPoints,
    );
  }

  @override
  List<Object?> get props => [id, name, email, address, bonusPoints];

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, address: $address, bonusPoints: $bonusPoints)';
  }
}
