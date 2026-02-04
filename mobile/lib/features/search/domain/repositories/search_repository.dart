import '../../../home/domain/entities/product.dart';

/// Search repository interface
/// Defines contracts for search operations in the domain layer
abstract class SearchRepository {
  /// Search products by query
  /// Returns list of products that match the search query
  Future<List<Product>> searchProducts(String query);

  /// Get popular products for initial search state
  /// Returns a list of popular/featured products
  Future<List<Product>> getPopularProducts();
}
