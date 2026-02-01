import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case to get products filtered by category
/// Follows Clean Architecture pattern
class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  /// Execute the use case
  /// Pass 'all' to get all products
  Future<List<Product>> call(String category) async {
    return await repository.getProductsByCategory(category);
  }
}
