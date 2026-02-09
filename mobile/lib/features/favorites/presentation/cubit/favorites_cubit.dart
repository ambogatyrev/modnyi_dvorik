import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/usecases/add_to_favorites.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/remove_from_favorites.dart';
import 'favorites_state.dart';

/// Cubit for managing favorites state globally
class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final AddToFavorites addToFavorites;
  final RemoveFromFavorites removeFromFavorites;

  FavoritesCubit({
    required this.getFavorites,
    required this.addToFavorites,
    required this.removeFromFavorites,
  }) : super(const FavoritesInitial());

  /// Load all favorites
  Future<void> loadFavorites() async {
    try {
      emit(const FavoritesLoading());
      final products = await getFavorites();
      final ids = products.map((p) => p.id).toSet();
      emit(FavoritesLoaded(favoriteIds: ids, products: products));
    } catch (e) {
      emit(FavoritesError(
        'Не удалось загрузить избранное: ${e.toString()}',
      ));
    }
  }

  /// Toggle favorite status for a product
  Future<void> toggleFavorite(Product product) async {
    try {
      final currentState = state;
      final wasFavorite = currentState is FavoritesLoaded &&
          currentState.isFavorite(product.id);

      if (wasFavorite) {
        await removeFromFavorites(product.id);
      } else {
        await addToFavorites(product.id);
      }

      // Reload favorites
      final products = await getFavorites();
      final ids = products.map((p) => p.id).toSet();
      emit(FavoritesLoaded(favoriteIds: ids, products: products));
    } catch (e) {
      emit(FavoritesError(
        'Не удалось обновить избранное: ${e.toString()}',
      ));
    }
  }
}
