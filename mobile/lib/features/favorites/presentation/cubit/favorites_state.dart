import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product.dart';

/// Base favorites state
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Loading state
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// Loaded state with favorite IDs and products
class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteIds;
  final List<Product> products;

  const FavoritesLoaded({
    required this.favoriteIds,
    required this.products,
  });

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  @override
  List<Object?> get props => [favoriteIds, products];
}

/// Error state
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
