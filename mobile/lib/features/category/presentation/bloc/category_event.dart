import 'package:equatable/equatable.dart';

/// Category screen events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load products for a specific category
class LoadCategoryProducts extends CategoryEvent {
  final String categoryId;

  const LoadCategoryProducts(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
