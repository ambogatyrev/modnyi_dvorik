import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product.dart';

/// Search screen states
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state showing popular products
class SearchInitial extends SearchState {
  final List<Product> popularProducts;

  const SearchInitial({this.popularProducts = const []});

  @override
  List<Object?> get props => [popularProducts];
}

/// Loading state while searching
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Loaded state with search results
class SearchLoaded extends SearchState {
  final List<Product> products;
  final String query;

  const SearchLoaded({
    required this.products,
    required this.query,
  });

  @override
  List<Object?> get props => [products, query];
}

/// Empty state when no results found
class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

/// Error state
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
