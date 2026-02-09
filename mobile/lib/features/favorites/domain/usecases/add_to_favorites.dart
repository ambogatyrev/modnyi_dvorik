import '../repositories/favorites_repository.dart';

/// Use case to add a product to favorites
class AddToFavorites {
  final FavoritesRepository repository;

  AddToFavorites(this.repository);

  Future<void> call(String productId) async {
    await repository.addToFavorites(productId);
  }
}
