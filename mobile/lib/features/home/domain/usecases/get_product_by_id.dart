import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case to get a single product by ID
/// Follows Clean Architecture pattern
class GetProductById {
  final ProductRepository repository;

  GetProductById(this.repository);

  /// Execute the use case
  /// Returns null if product is not found
  Future<Product?> call(String id) async {
    return await repository.getProductById(id);
  }
}
