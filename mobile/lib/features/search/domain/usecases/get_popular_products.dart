import '../../../home/domain/entities/product.dart';
import '../repositories/search_repository.dart';

/// Use case to get popular products for initial search state
/// Follows Clean Architecture pattern
class GetPopularProducts {
  final SearchRepository repository;

  GetPopularProducts(this.repository);

  /// Execute the use case
  /// Returns list of popular/featured products
  Future<List<Product>> call() async {
    return await repository.getPopularProducts();
  }
}
