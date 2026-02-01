import '../../../../core/data/mock_products.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

/// Product repository implementation using mock data
/// Converts ProductModel to Product entity
class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Get mock products and convert to entities
    final products = getAllProducts();
    return products.map((model) => _mapToEntity(model)).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Get product from mock data (using different function name to avoid conflict)
    final productModel = mockProducts.cast<ProductModel?>().firstWhere(
      (p) => p?.id == id,
      orElse: () => null,
    );

    if (productModel == null) {
      return null;
    }

    return _mapToEntity(productModel);
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Get products by category from mock data
    List<ProductModel> productModels;
    if (category == 'all') {
      productModels = mockProducts;
    } else {
      productModels = mockProducts.where((p) => p.category == category).toList();
    }

    return productModels.map((model) => _mapToEntity(model)).toList();
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
