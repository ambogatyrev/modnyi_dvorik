import 'package:equatable/equatable.dart';

/// User data model for profile and account information
class UserModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String address;
  final int bonusPoints;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.bonusPoints,
    required this.password,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      bonusPoints: json['bonusPoints'] as int,
      password: json['password'] as String,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'bonusPoints': bonusPoints,
      'password': password,
    };
  }

  /// Create a copy of UserModel with modified fields
  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    int? bonusPoints,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bonusPoints: bonusPoints ?? this.bonusPoints,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, address, bonusPoints, password];

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, address: $address, bonusPoints: $bonusPoints)';
  }
}
