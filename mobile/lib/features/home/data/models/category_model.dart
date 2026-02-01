import 'package:equatable/equatable.dart';

/// Category data model for product categorization
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String icon; // Emoji icon

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  /// Create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }

  /// Convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  /// Create a copy of CategoryModel with modified fields
  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [id, name, icon];

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, icon: $icon)';
  }
}
