import '../../../home/domain/entities/product.dart';
import '../repositories/favorites_repository.dart';

/// Use case to get all favorite products
class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<List<Product>> call() async {
    return repository.getFavoriteProducts();
  }
}
