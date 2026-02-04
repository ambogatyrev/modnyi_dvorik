import '../../../../core/data/mock_products.dart';
import '../../../home/data/models/product_model.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/repositories/search_repository.dart';

/// Search repository implementation using mock data
/// Implements search logic with case-insensitive filtering
class SearchRepositoryImpl implements SearchRepository {
  @override
  Future<List<Product>> searchProducts(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    if (query.trim().isEmpty) {
      return [];
    }

    // Convert query to lowercase for case-insensitive search
    final lowerQuery = query.toLowerCase().trim();

    // Filter products where name contains the query
    final filteredProducts = mockProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery);
    }).toList();

    return filteredProducts.map((model) => _mapToEntity(model)).toList();
  }

  @override
  Future<List<Product>> getPopularProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return first 20 products as "popular"
    // In a real app, this would be based on sales, ratings, etc.
    final popularProducts = mockProducts.take(20).toList();

    return popularProducts.map((model) => _mapToEntity(model)).toList();
  }

  /// Map ProductModel to Product entity
  Product _mapToEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      price: model.price,
      image: model.image,
      category: model.category,
    );
  }
}
