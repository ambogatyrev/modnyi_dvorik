import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Use case to get all products
/// Follows Clean Architecture pattern
class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  /// Execute the use case
  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
