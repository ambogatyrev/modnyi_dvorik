import '../../../../core/data/mock_favorites_storage.dart';
import '../../../../core/data/mock_products.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/repositories/favorites_repository.dart';

/// Favorites repository implementation using mock data
class FavoritesRepositoryImpl implements FavoritesRepository {
  final MockFavoritesStorage _storage = MockFavoritesStorage();

  @override
  Future<Set<String>> getFavoriteIds() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _storage.getFavoriteIds();
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final ids = _storage.getFavoriteIds();
    return mockProducts
        .where((model) => ids.contains(model.id))
        .map(
          (model) => Product(
            id: model.id,
            name: model.name,
            price: model.price,
            image: model.image,
            category: model.category,
          ),
        )
        .toList();
  }

  @override
  Future<void> addToFavorites(String productId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _storage.add(productId);
  }

  @override
  Future<void> removeFromFavorites(String productId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _storage.remove(productId);
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return _storage.isFavorite(productId);
  }
}
