import '../repositories/favorites_repository.dart';

/// Use case to remove a product from favorites
class RemoveFromFavorites {
  final FavoritesRepository repository;

  RemoveFromFavorites(this.repository);

  Future<void> call(String productId) async {
    await repository.removeFromFavorites(productId);
  }
}
