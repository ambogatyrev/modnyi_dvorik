import '../../../home/domain/entities/product.dart';

/// Favorites repository interface
/// Defines contracts for favorites operations in the domain layer
abstract class FavoritesRepository {
  /// Get all favorite product IDs
  Future<Set<String>> getFavoriteIds();

  /// Get all favorite products
  Future<List<Product>> getFavoriteProducts();

  /// Add a product to favorites
  Future<void> addToFavorites(String productId);

  /// Remove a product from favorites
  Future<void> removeFromFavorites(String productId);

  /// Check if a product is in favorites
  Future<bool> isFavorite(String productId);
}
