import 'package:equatable/equatable.dart';

/// Home screen events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load products
class LoadProducts extends HomeEvent {
  const LoadProducts();
}

/// Event to select a category and filter products
class SelectCategory extends HomeEvent {
  final String categoryId;

  const SelectCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
