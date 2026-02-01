import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product.dart';

/// Category screen states
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Loading state
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// Loaded state with products and category information
class CategoryLoaded extends CategoryState {
  final List<Product> products;
  final String categoryId;
  final String categoryName;

  const CategoryLoaded({
    required this.products,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [products, categoryId, categoryName];
}

/// Error state
class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
