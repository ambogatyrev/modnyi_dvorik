import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

/// Home screen states
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded state with products and selected category
class HomeLoaded extends HomeState {
  final List<Product> products;
  final String selectedCategory;

  const HomeLoaded({
    required this.products,
    this.selectedCategory = 'all',
  });

  @override
  List<Object?> get props => [products, selectedCategory];

  /// Create a copy with updated fields
  HomeLoaded copyWith({
    List<Product>? products,
    String? selectedCategory,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
