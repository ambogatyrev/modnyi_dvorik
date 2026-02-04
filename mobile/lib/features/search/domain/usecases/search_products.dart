import '../../../home/domain/entities/product.dart';
import '../repositories/search_repository.dart';

/// Use case to search products by query
/// Follows Clean Architecture pattern
class SearchProducts {
  final SearchRepository repository;

  SearchProducts(this.repository);

  /// Execute the use case
  /// Returns list of products matching the search query
  Future<List<Product>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await repository.searchProducts(query);
  }
}
