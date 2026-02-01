import '../entities/product.dart';

/// Product repository interface
/// Defines contracts for product data operations in the domain layer
abstract class ProductRepository {
  /// Get all products
  Future<List<Product>> getProducts();

  /// Get a single product by ID
  /// Returns null if product is not found
  Future<Product?> getProductById(String id);

  /// Get products filtered by category
  /// Pass 'all' to get all products
  Future<List<Product>> getProductsByCategory(String category);
}
